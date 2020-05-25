import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/user.dart';

class BaseController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // COLLECTIONS
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference itemsCollection = Firestore.instance.collection('items');
  final CollectionReference ordersCollection = Firestore.instance.collection('orders');
  final CollectionReference devicesCollection = Firestore.instance.collection('devices');

  // MAP FIREBASE SNAPSHOT TO ITEM CLASS
  List<Item> itemsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Item(
        id: doc.documentID ?? '',
        name: doc.data['name'] ?? '',
        image: doc.data['image'],
        price: doc.data['price'] ?? 0,
      );
    }).toList();
  }

  // MAP FIREBASE SNAPSHOT TO ORDER CLASS
  List<Order> ordersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Order(
        id: doc.documentID ?? '',
        deviceID: doc.data['deviceID'] ?? '',
        itemID: doc.data['itemID'],
        quantity: doc.data['quantity'] ?? 0,
        status: doc.data['status'] ?? '',
        assignee: doc.data['assignee'] ?? '',
        creationTime: doc.data['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'].millisecondsSinceEpoch, isUtc: true) : DateTime.now()
      );
    }).toList();
  }

  // MAP FIREBASE SNAPSHOT TO USER CLASS
  List<User> usersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User(
        id: doc.data['id'] ?? '',
        email: doc.data['email'] ?? '',
        name: doc.data['name'] ?? '',
        role: doc.data['role'] ?? '',
      );
    }).toList();
  }

  // add order if it does not exists inside the list.
  void addUniqueOrder(List<Order> list, Order order) {
    if (list.indexOf(order) < 0) {
      list.add(order);
    }
  }

  // removes given order from given list 
  void removeOrder(List<Order> list, Order order) {
    list.remove(order);
  }

}
