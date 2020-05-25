import 'package:sanal_menu/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanal_menu/models/order.dart';

class Customer extends User {
  final CollectionReference ordersCollection = Firestore.instance.collection('orders');

  // ADD ORDER TO CART

  // MODIFY ORDER QUANTITY
  void modifyOrder(Order order, int quantity) {
    order.setQuantity(quantity);
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
