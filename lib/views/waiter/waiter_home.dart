import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/waiter_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:sanal_menu/views/waiter/tabs/waiter_assignments.dart';
import 'package:sanal_menu/views/waiter/tabs/waiter_orders.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/waiter/tabs/waiter_payments.dart';

class WaiterHome extends StatefulWidget {
  @override
  _WaiterHomeState createState() => _WaiterHomeState();
}

class _WaiterHomeState extends State<WaiterHome> {
  int _currentIndex = 0;

  Stream<List<Future<Order>>> ordersStream = WaiterController().readyOrders;
  Stream<List<Future<Order>>> assignmentsStream = WaiterController().assignments;
  Stream<List<Future<Order>>> paymentRequestsStream = WaiterController().paymentRequests;
  Stream<List<Future<Order>>> assignedPaymentRequestsStream = WaiterController().assignedPaymentRequests;

  // TAB SWITCHER
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ordersStream,
      builder: (context, orders) {
        return StreamBuilder(
          stream: assignmentsStream,
          builder: (context, assignment) {
            return StreamBuilder(
              stream: paymentRequestsStream,
              builder: (context, paymentRequests) {
                return StreamBuilder(
                    stream: assignedPaymentRequestsStream,
                    builder: (context, assignedPaymentRequests) {
                      final List<Widget> _children = [
                        WaiterOrder(snapshot: orders),
                        WaiterPayments(paymentsSnapshot: paymentRequests, assignedPaymentsSnapshot: assignedPaymentRequests),
                        WaiterAssignments(snapshot: assignment),
                      ];
                      return Scaffold(
                        appBar: appBarAuth(context),
                        body: _children[_currentIndex],
                        bottomNavigationBar: BottomNavigationBar(
                          onTap: onTabTapped,
                          currentIndex: _currentIndex,
                          items: [
                            BottomNavigationBarItem(
                              icon: new Icon(Icons.local_dining),
                              title: new Text('Ready Orders'),
                            ),
                            BottomNavigationBarItem(
                              icon: new Icon(Icons.attach_money),
                              title: new Text('Payments Requests'),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.room_service),
                              title: Text('Assignments'),
                            )
                          ],
                        ),
                      );
                    });
              },
            );
          },
        );
      },
    );
  }
}
