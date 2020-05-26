import 'package:flutter/cupertino.dart';
import 'package:sanal_menu/controllers/stream_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order extends ChangeNotifier {
  Order({this.id, this.deviceID, this.itemID, this.creationTime, int quantity, String status, String assignee}) {
    setQuantity(quantity);
    setStatus(status);
    setAssignee(assignee);
    // Accesing to item name which this order
    StreamController().getItemByID(itemID).then((item) {
      setName(item.name);
    });
    // Accesing to device name which owns this order.
    StreamController().getDeviceByID(deviceID).then((device) {
      setDeviceName(device.name);
    });
  }

  // Unique id of this record on Firebase.
  String id;

  // Holds device id which this order is made.
  String deviceID;

  // Holds device display name.
  String _deviceName = 'Unknown';
  String get deviceName => _deviceName;
  void setDeviceName(String value) {
    _deviceName = value;
    notifyListeners();
  }

  // Holds catalog item id which this order record represents.
  String itemID;

  bool isSelected = false;

  // Name of the catalog item. This column does not exist in Firebase.
  // Thus it is accessed by matching itemID on items collection.
  String _name = "Unknown";
  String get name => _name;
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  // Holds order confirmation timestamp.
  DateTime creationTime;
  String getCreationTime() {
    String hour = creationTime.toLocal().hour.toString() + ":" + creationTime.toLocal().minute.toString();
    //String day = creationTime.toLocal().day.toString() + "." + creationTime.toLocal().month.toString() + "." + creationTime.toLocal().year.toString();
    return hour;
  }

  // Indicates currently assigned user. Takes uid of that user.
  // If no one is assigned then value is an empty string.
  String _assignee;
  String get assignee => _assignee;
  void setAssignee(String value) {
    _assignee = value;
  }

  // Holds how many of this item should be.
  int _quantity;
  int get quantity => _quantity;
  void setQuantity(int value) {
    if (value == 0)
      this.delete();
    else
      _quantity = value;
  }

  // Indicates current status of this order.Has 7 different possible values.
  // Which are: 1-InCart 2-Ordered 3-Preparing 4-Ready 5-Serving 6-Served 7-Paid
  String _status;
  String get status => _status;
  void setStatus(String value) {
    List<String> possibleValues = ['InCart', 'Ordered', 'Preparing', 'Ready', 'Serving', 'Served', 'Paid', null];
    // If given parameter value is inside the list set value.
    if (possibleValues.contains(value))
      _status = value;
    else
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
    if (query.documents.length == 0) {
      Firestore.instance.collection('orders').add({
        'deviceID': this.deviceID,
        'itemID': this.itemID,
        'quantity': this.quantity,
        'status': this.status,
        'assignee': this.assignee,
        'timestamp': this.creationTime,
      });
    } else {
      throw "Record already exists.";
    }
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
