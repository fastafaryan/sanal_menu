import 'package:sanal_menu/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_id/device_id.dart';
import 'package:sanal_menu/models/order.dart';

class Customer extends User {
  final CollectionReference ordersCollection = Firestore.instance.collection('orders');

  // ADD ORDER TO CART
  Future addToCart(String itemID) async {
    final CollectionReference ordersCollection = Firestore.instance.collection('orders');
    DocumentReference record = await ordersCollection.add({
      'deviceID': await DeviceId.getID,
      'itemID': itemID,
      'quantity': 1,
      'status': 'InCart',
      'assignee': null,
      'timestamp': DateTime.now(),
    });
    return record.documentID;
  }

  // MODIFY ORDER QUANTITY
  void modifyOrder(String orderID, int quantity) {
    DocumentReference ref = ordersCollection.document(orderID);
    if (ref == null) return;
    if (quantity == 0)
      this.removeOrder(orderID);
    else
      ref.updateData({'quantity': quantity});
  }

  // REMOVE ORDER. CALLED INSIDE CART BEFORE ORDER WAS CONFIRMSED.
  void removeOrder(String orderID) {
    ordersCollection.document(orderID).delete();
  }

  // COMFIRM ALL ORDERS INSIDE THE CART.
  void completeOrders(List<Order> orders) {
    orders.forEach((order) {
      ordersCollection.document(order.id).updateData({'status': 'Ordered'});
    });
    return;
  }

  // CANCEL CONFIRMED ORDER
  void cancelOrder(Order order) {
    ordersCollection.document(order.id).delete();
  }

  
}
