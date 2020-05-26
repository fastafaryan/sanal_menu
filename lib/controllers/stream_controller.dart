import 'package:sanal_menu/models/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/models/user.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'dart:async';
import 'package:device_id/device_id.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreamController extends BaseController {
  AuthController _authService = AuthController();

  // STREAM OF ALL CURRENT USER CART ITEMS
  Stream<List<Order>> get userCartItems async* {
    String deviceID = await DeviceId.getID;
    yield* ordersCollection.where('deviceID', isEqualTo: deviceID).where('status', isEqualTo: 'InCart').snapshots().map(ordersFromSnapshot);
  }

  // STREAM OF CURRENT USER ORDERS
  Stream<List<Order>> get userOrders async* {
    String deviceID = await DeviceId.getID;
    yield* ordersCollection
        .where('deviceID', isEqualTo: deviceID)
        .where('status', whereIn: ['Ordered','Preparing','Ready','Serving','Served'])
        .snapshots()
        .map(ordersFromSnapshot);
  }

  // sTREAM OF ALL USERS
  Stream<List<User>> get users {
    return usersCollection.snapshots().map(usersFromSnapshot);
  }

  Stream<List<Order>> get allOrders {
    return ordersCollection.where('status', isEqualTo: "Ordered").snapshots().map((ordersFromSnapshot));
  }

  Stream<List<Order>> get cookAssignments async* {
    String uid = await _authService.getCurrentUserId();
    yield* ordersCollection.where('status', isEqualTo: "Preparing").where('assignee', isEqualTo: uid).snapshots().map(ordersFromSnapshot);
  }

  Stream<List<User>> get checkUserRole async* {
    String uid = await _authService.getCurrentUserId();
    yield* usersCollection.where('uid', isEqualTo: uid).snapshots().map(usersFromSnapshot);
  }

  Stream<List<Order>> getOrderByItem(String itemID) async* {
    String deviceID = await DeviceId.getID;
    yield* ordersCollection.where('deviceID', isEqualTo: deviceID).where('itemID', isEqualTo: itemID).snapshots().map(ordersFromSnapshot);
  }

  // ACCESSING ITEM BY ITS ID. USED TO ACCESS ITEM THROUGH ORDER.
  Future<Item> getItemByID(String itemID) {
    return itemsCollection.document(itemID).get().then((doc) {
      return Item(
        id: doc.documentID ?? '',
        name: doc.data['name'] ?? '',
        image: doc.data['image'],
        price: doc.data['price'] ?? 0,
      );
    });
  }

  // ACCESSING ITEM BY ITS ID. USED TO ACCESS ITEM THROUGH ORDER.
  Future<Device> getDeviceByID(String deviceID) async {
    QuerySnapshot query = await devicesCollection.where('id', isEqualTo: deviceID).getDocuments();
    if (query.documents.length == 1) {
      return devicesCollection.document(query.documents.first.documentID).get().then((doc) {
        return Device(
          id: doc.documentID ?? '',
          name: doc.data['name'] ?? '',
        );
      });
    } else if (query.documents.length > 1)
      throw "Duplicate records exist";
    else
      throw "Record not found.";
  }

  // STREAM OF ALL MENU ITEMS
  Stream<List<Item>> get menuItems {
    return Firestore.instance.collection('items').snapshots().map(itemsFromSnapshot);
  }

  // STREAM OF ALL DEVICES
  Stream<List<Device>> get devices {
    return Firestore.instance.collection('devices').snapshots().map((doc) {
      return doc.documents.map((doc) {
        return Device(
          id: doc.data['id'] ?? '',
          name: doc.data['name'] ?? '',
        );
      }).toList();
    });
  }

  // Stream for prepared food for serving.
  Stream<List<Order>> get readyOrders {
    return ordersCollection.where('status', isEqualTo: 'Ready').where('assignee', isEqualTo: null).orderBy('timestamp', descending: false).snapshots().map(ordersFromSnapshot);
  }

  // Stream for prepared food for serving.
  Stream<List<Order>> get assignments async*{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser(); // gets current user.
    yield* ordersCollection.where('status', isEqualTo: 'Serving').where('assignee', isEqualTo: user.uid).orderBy('timestamp', descending: false).snapshots().map(ordersFromSnapshot);
  }
}
