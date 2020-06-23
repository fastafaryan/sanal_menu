import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:sanal_menu/controllers/stream_controller.dart_';
import 'package:sanal_menu/models/device.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/user.dart';
import 'package:device_id/device_id.dart';

enum MessageTypes { success, error, warning, info }

class FunctionFeedback {
  FunctionFeedback({this.type, this.message});
  MessageTypes type;
  String message;
}

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
  List<Future<Order>> ordersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(orderFromSnapshot).toList();
  }

  Future<Order> orderFromSnapshot(DocumentSnapshot doc) async {
    Item item = await BaseController().getItemByID(doc['itemID']);
    Device device = await BaseController().getDeviceByID(doc['deviceID']);
    return Order(
      id: doc.documentID ?? '',
      deviceName: device != null ? device.name : 'Unknown',
      deviceID: doc.data['deviceID'] ?? '',
      itemID: doc.data['itemID'],
      itemName: item.name ?? 'Unknown',
      itemPrice: item.price,
      quantity: doc.data['quantity'] ?? 0,
      status: doc.data['status'] ?? '',
      assignee: doc.data['assignee'] ?? '',
      creationTime: doc.data['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'].millisecondsSinceEpoch, isUtc: true)
          : DateTime.now(),
    );
  }

  // MAP FIREBASE SNAPSHOT TO USER CLASS
  List<User> usersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User(
        id: doc.data['uid'] ?? '',
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

  Stream<List<Future<Order>>> getOrderByItemID(String itemID) async* {
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
    } else if (query.documents.length > 1) throw "Duplicate records exist";
    //else throw "Record not found.";
  }

}
