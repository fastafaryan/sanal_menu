import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sanal_menu/models/order.dart';

class Payment {
  Payment({this.deviceName, this.totalPrice, this.orders});
  String deviceName;
  double totalPrice;
  List<Order> orders;
}

class WaiterPaymentsController extends ChangeNotifier with BaseController {
  List<Payment> payments;
  List<Payment> assignedPayments;

  void setPayments(List<Future<Order>> futures) {
    // clear previous records
    clearPayments();

    // init list if it is null
    if (payments == null) payments = [];

    // run loop for each future order in the list
    futures.forEach((future) {
      // wait for future to complete
      future.then((order) {
        // checker for if this device is alreay in the list
        bool isExisting = false;
        for (Payment payment in payments) {
          // if it is in the list order under the same record.
          if (order.deviceName == payment.deviceName) {
            isExisting = true;
            payment.totalPrice += order.itemPrice * order.quantity;
            payment.orders.add(order);
          }
        }

        // if this device has no recourd in paymentsList add as a new record.
        if (isExisting == false) {
          // define payment
          Payment newPayment = Payment(
            deviceName: order.deviceName,
            totalPrice: order.itemPrice * order.quantity,
            orders: [order],
          );
          // add to list
          payments.add(newPayment);
          // notify
          notifyListeners();
        }
      });
    });
  }

  void clearPayments() {
    if (payments != null) {
      payments.clear();
      notifyListeners();
    }
  }

  void setAssignedPayments(List<Future<Order>> futures) {
    // clear previous records
    clearAssignedPayments();

    // init list if it is null
    if (assignedPayments == null) assignedPayments = [];

    // run loop for each future order in the list
    futures.forEach((future) {
      // wait for future to complete
      future.then((order) {
        // checker for if this device is alreay in the list
        bool isExisting = false;
        for (Payment payment in assignedPayments) {
          // if it is in the list order under the same record.
          if (order.deviceName == payment.deviceName) {
            isExisting = true;
            payment.totalPrice += order.itemPrice * order.quantity;
            payment.orders.add(order);
          }
        }

        // if this device has no recourd in paymentsList add as a new record.
        if (isExisting == false) {
          // define payment
          Payment newPayment = Payment(
            deviceName: order.deviceName,
            totalPrice: order.itemPrice * order.quantity,
            orders: [order],
          );
          // add to list
          assignedPayments.add(newPayment);
          // notify
          notifyListeners();
        }
      });
    });
  }

  void clearAssignedPayments() {
    if (assignedPayments != null) {
      assignedPayments.clear();
      notifyListeners();
    }
  }

  Future startPayment(Payment payment) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser(); // gets current user.
    for (Order order in payment.orders) {
      order.setStatus('Paying');
      order.setAssignee(user.uid);
      order.update();
    }
  }

  Future cancelPayment(Payment payment) async {
    for (Order order in payment.orders) {
      order.setStatus('PaymentRequested');
      order.setAssignee(null);
      order.update();
    }
  }

  Future setPaymentDone(Payment payment) async {
    for (Order order in payment.orders) {
      order.setStatus('Paid');
      order.setAssignee(null);
      order.update();
    }
  }

  Future<bool> isAssignedPayment(Payment payment) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser(); // gets current user.
    bool returnValue = false;
    for (Order order in payment.orders) {
      if (order.assignee == user.uid) returnValue = true;
    }

    return returnValue;
  }
}
