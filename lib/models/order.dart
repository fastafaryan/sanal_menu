import 'package:flutter/cupertino.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:sanal_menu/controllers/stream_controller.dart_';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  Order(
      {this.id,
      this.deviceID,
      this.itemID,
      this.itemName,
      this.itemPrice,
      this.creationTime,
      this.deviceName,
      int quantity,
      String status,
      String assignee}) {
    setQuantity(quantity);
    setStatus(status);
    setAssignee(assignee);
  }

  // Properties
  String id;
  String deviceID;
  String deviceName = 'Unknown';
  String itemID;
  String itemName = "Unknown";
  double itemPrice;
  bool isSelected = false;
  DateTime creationTime;
  String _assignee;
  int _quantity;
  String _status;

  // Holds order confirmation timestamp.
  String getCreationTime() {
    String hour = creationTime.toLocal().hour.toString() + ":" + creationTime.toLocal().minute.toString();
    //String day = creationTime.toLocal().day.toString() + "." + creationTime.toLocal().month.toString() + "." + creationTime.toLocal().year.toString();
    return hour;
  }

  // Indicates currently assigned user. Takes uid of that user.
  // If no one is assigned then value is an empty string.
  String get assignee => _assignee;
  void setAssignee(String value) {
    _assignee = value;
  }

  // Holds how many of this item should be.
  int get quantity => _quantity;
  void setQuantity(int value) {
    if (value == 0)
      this.delete();
    else
      _quantity = value;
  }

  // Indicates current status of this order.Has 7 different possible values.
  // Which are: 1-InCart 2-Ordered 3-Preparing 4-Ready 5-Serving 6-Served 7-Paid
  List<String> possibleStatuses = ['InCart', 'Ordered', 'Preparing', 'Ready', 'Serving', 'Served', 'PaymentRequested', 'Paying', 'Paid', null];
  String get status => _status;
  void setStatus(String value) {
    // If given parameter value is inside the list set value.
    if (possibleStatuses.contains(value))
      _status = value;
    else
      throw "Tried to assign undefined value to {order.status}.";
  }

  void updateStatus(String value) {
    // If given parameter value is inside the list set value.
    if (possibleStatuses.contains(value)) {
      _status = value;
      Firestore.instance.collection('orders').document(this.id).updateData({'status': _status});
    } else
      throw "Tried to assign undefined value to {order.status}.";
  }

  void toggleSelection() {
    isSelected = !isSelected;
  }

  // Inserts this record to DB if same itemID and deviceID pair does not exist.
  Future insert() async {
    // Query if same itemID and deviceID pair does not exist.
    QuerySnapshot query = await Firestore.instance
        .collection('orders')
        .where('deviceID', isEqualTo: this.deviceID)
        .where('itemID', isEqualTo: this.itemID)
        .getDocuments();

    // If same record does not exist insert record to DB.
    Firestore.instance.collection('orders').add({
      'deviceID': this.deviceID,
      'itemID': this.itemID,
      'quantity': this.quantity,
      'status': this.status,
      'assignee': this.assignee,
      'timestamp': this.creationTime,
    });
  }

// Updates this order's record on DB if exists.
  Future update() async {
    Firestore.instance.collection('orders').document(this.id).updateData({
      'deviceID': this.deviceID,
      'itemID': this.itemID,
      'quantity': this.quantity,
      'status': this.status,
      'assignee': this.assignee,
      'timestamp': this.creationTime,
    });
  }

  Future delete() async {
    Firestore.instance.collection('orders').document(this.id).delete();
  }
}
