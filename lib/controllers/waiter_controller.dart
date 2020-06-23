import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaiterController extends ChangeNotifier with BaseController {
  // list for storing selected orders by checking checkboxes in the UI.
  final List<Order> _selectedOrders = [];
  final List<Order> _selectedAssignments = [];

  // Stream for prepared food for serving.
  Stream<List<Future<Order>>> get readyOrders {
    return ordersCollection
        .where('status', isEqualTo: 'Ready')
        .where('assignee', isEqualTo: null)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(ordersFromSnapshot);
  }

  // Stream for prepared food for serving.
  Stream<List<Future<Order>>> get assignments async* {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser(); // gets current user.
    yield* ordersCollection
        .where('status', isEqualTo: 'Serving')
        .where('assignee', isEqualTo: user.uid)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(ordersFromSnapshot);
  }

  // Stream for prepared food for serving.
  Stream<List<Future<Order>>> get paymentRequests async* {
    yield* ordersCollection
        .where('status', isEqualTo: 'PaymentRequested')
        .where('assignee', isEqualTo: null)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(ordersFromSnapshot);
  }

  // Stream for prepared food for serving.
  Stream<List<Future<Order>>> get assignedPaymentRequests async* {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser(); // gets current user.
    yield* ordersCollection
        .where('status', isEqualTo: 'Paying')
        .where('assignee', isEqualTo: user.uid)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(ordersFromSnapshot);
  }

  // adds or removes order to selected orders list depending on the checkbox value.
  void toggleSelection(Order order) {
    order.toggleSelection(); // toggle selection value.
    notifyListeners(); // notify listener widgets for update.

    // add to corresponding list based on order status. Here checks for unprepared orders
    if (order.status == 'Ready') {
      // add or remove from list depending on value.
      if (order.isSelected == true)
        this.addUniqueOrder(this._selectedOrders, order);
      else
        removeOrder(this._selectedOrders, order);
    }

    // add to corresponding list based on order status.  Here checks for assigned orders
    if (order.status == 'Serving') {
      // add or remove from list depending on value.
      if (order.isSelected == true)
        this.addUniqueOrder(this._selectedAssignments, order);
      else
        removeOrder(this._selectedAssignments, order);
    }
  }

  // assigns orders in selected orders list to currently signed user.
  Future assignOrder() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser(); // gets current user.

    // runs a loop for each selected orders. updates their assignee field to current user's uid.
    this._selectedOrders.forEach((order) {
      Firestore.instance.collection('orders').document(order.id).updateData({'assignee': user.uid, 'status': 'Serving'}); // update DB
      order.toggleSelection(); // set order model class value to false
    });

    this._selectedOrders.clear(); // clears selected orders list
    notifyListeners(); // notifies listener widgets for update.
    return "Orders are assigned.";
  }

  String setAsDone() {
    // runs a loop for each selected assignments. updates their status to ready and assignee to null
    this._selectedAssignments.forEach((order) {
      Firestore.instance.collection('orders').document(order.id).updateData({'assignee': null, 'status': 'Served'}); // update DB
      order.toggleSelection(); // set order model class value to false
    });

    this._selectedAssignments.clear(); // clears selected orders list
    notifyListeners(); // notifies listener widgets for update.
    return "Orders are assigned as served";
  }

  // Release assignment
  String releaseAssignments() {
    // runs a loop for each selected orders. updates their assignee field to null.
    this._selectedAssignments.forEach((order) {
      order.setStatus('Ready');
      order.setAssignee(null);
      order.toggleSelection(); // set order model class value to false
      order.update();
    });
    return "Order released.";
  }
}
