import 'package:flutter/cupertino.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_id/device_id.dart';

class CustomerController extends ChangeNotifier with BaseController {

  Future addToCart(String itemID) async {
    // Create an instance for Order which will be added to cart.
    Order order = Order(
      deviceID: await DeviceId.getID,
      itemID: itemID,
      quantity: 1,
      status: 'InCart',
    );
    order.insert();
  }

  // MODIFY ORDER QUANTITY
  void modifyOrder(Order order, int quantity) {
    if (quantity == 0) {
      deleteOrder(order);
    } else {
      order.setQuantity(quantity);
      order.update();
    }
  }

  // CHECK ORDER STATUS AND IF IT IS NOT STARTED TO BE COOKED, DELETES ORDER.
  void deleteOrder(Order order) {
    if (order.status == 'Ordered' || order.status == 'InCart') order.delete();
  }

  // COMFIRM ALL ORDERS INSIDE THE CART.
  void completeOrders(List<Future<Order>> orders) {
    orders.forEach((futures) {
      futures.then((orders) {
        orders.setStatus('Ordered');
        orders.update();
      });
    });
  }

  Future<bool> canRequestPayment() async {
    bool returnValue = true;
    String deviceID = await DeviceId.getID;
    // get all orders belonging to this user
    QuerySnapshot querySnapshot = await ordersCollection.where('deviceID', isEqualTo: deviceID).getDocuments();
    if (querySnapshot.documents.length == 0) {
      return false;
    }
    // check status for each order if at least of the order status is not equeal to served then return false
    for (final doc in querySnapshot.documents) {
      if (doc.data['status'] != 'Served') {
        returnValue = false;
        break;
      }
    }
    return returnValue;
  }

  Future<Map> requestPayment() async {
    bool canRequest = await canRequestPayment();

    if (canRequest == true) {
      String deviceID = await DeviceId.getID;
      QuerySnapshot querySnapshot = await ordersCollection.where('deviceID', isEqualTo: deviceID).getDocuments();
      List<Future<Order>> orders = ordersFromSnapshot(querySnapshot);
      orders.forEach((orderFuture) {
        orderFuture.then((order) {
          order.setStatus('PaymentRequested');
          order.update();
        });
      });
      return {'type': MessageTypes.success, 'message': 'Payment requested.'};
    } else {
      return {'type': MessageTypes.error, 'message': 'Payment request could not been made.'};
    }
  }

  Future<bool> isRequestedPayment() async {
    bool returnValue = true;
    String deviceID = await DeviceId.getID;
    // get all orders belonging to this user
    QuerySnapshot querySnapshot = await ordersCollection.where('deviceID', isEqualTo: deviceID).getDocuments();
    // check status for each order if at least of the order status is not equeal to served then return false
    for (final doc in querySnapshot.documents) {
      if (doc.data['status'] != 'PaymentRequested') {
        returnValue = false;
        break;
      }
    }
    return returnValue;
  }

  Future cancelPaymentRequest() async {
    String deviceID = await DeviceId.getID;
    QuerySnapshot querySnapshot = await ordersCollection.where('deviceID', isEqualTo: deviceID).getDocuments();
    List<Future<Order>> orders = ordersFromSnapshot(querySnapshot);
    orders.forEach((orderFuture) {
      orderFuture.then((order) {
        order.setStatus('Served');
        order.update();
      });
    });
    return {'type': MessageTypes.success, 'message': 'Payment request has been canceled.'};
  }
}
