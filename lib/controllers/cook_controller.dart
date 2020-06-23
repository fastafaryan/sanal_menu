import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CookController extends ChangeNotifier with BaseController {
  // list for storing selected orders by checking checkboxes in the UI.
  final List<Order> _selectedOrders = [];
  final List<Order> _selectedAssignments = [];

  Stream<List<Future<Order>>> get orders {
    return ordersCollection.where('status', isEqualTo: "Ordered").snapshots().map((ordersFromSnapshot));
  }

  Stream<List<Future<Order>>> get assignments async* {
    String uid = await AuthController().getCurrentUserId();
    yield* ordersCollection.where('status', isEqualTo: "Preparing").where('assignee', isEqualTo: uid).snapshots().map(ordersFromSnapshot);
  }

  // adds or removes order to selected orders list depending on the checkbox value.
  void toggleSelection(Order order) {
    order.toggleSelection(); // toggle selection value.
    notifyListeners(); // notify listener widgets for update.

    // add to corresponding list based on order status. Here checks for unprepared orders
    if (order.status == 'Ordered') {
      // add or remove from list depending on value.
      if (order.isSelected == true)
        this.addUniqueOrder(_selectedOrders, order);
      else
        removeOrder(_selectedOrders, order);
    }

    // add to corresponding list based on order status.  Here checks for assigned orders
    if (order.status == 'Preparing') {
      // add or remove from list depending on value.
      if (order.isSelected == true)
        this.addUniqueOrder(_selectedAssignments, order);
      else
        removeOrder(_selectedAssignments, order);
    }
  }

  // assigns orders in selected orders list to currently signed user.
  Future<String> assignOrder() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser(); // gets current user.

    // runs a loop for each selected orders. updates their assignee field to current user's uid.
    this._selectedOrders.forEach((order) {
      Firestore.instance.collection('orders').document(order.id).updateData({'assignee': user.uid, 'status': 'Preparing'}); // update DB
      order.toggleSelection(); // set order model class value to false
    });

    this._selectedOrders.clear(); // clears selected orders list
    notifyListeners(); // notifies listener widgets for update.
    return "Orders are assigned to you successfully.";
  }

  String setAsReady() {
    // runs a loop for each selected assignments. updates their status to ready and assignee to null
    this._selectedAssignments.forEach((order) {
      Firestore.instance.collection('orders').document(order.id).updateData({'assignee': null, 'status': 'Ready'}); // update DB
      order.toggleSelection(); // set order model class value to false
    });

    this._selectedAssignments.clear(); // clears selected orders list
    notifyListeners(); // notifies listener widgets for update.
    return "Orders are set as ready.";
  }

  // Release assignment
  String releaseAssignments() {
    // runs a loop for each selected orders. updates their assignee field to null.
    this._selectedAssignments.forEach((order) {
      order.setStatus('Ordered');
      order.setAssignee(null);
      order.toggleSelection(); // set order model class value to false
      order.update();
    });
    return "Order released.";
  }
}
