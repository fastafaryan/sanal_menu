import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/waiter_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:sanal_menu/views/waiter/tabs/waiter_assignments.dart';
import 'package:sanal_menu/views/waiter/tabs/waiter_orders.dart';
import 'package:flutter/material.dart';

class WaiterHome extends StatefulWidget {
  @override
  _WaiterHomeState createState() => _WaiterHomeState();
}

class _WaiterHomeState extends State<WaiterHome> {
  int _currentIndex = 0;
  Stream<List<Order>> readyOrders = WaiterController().readyOrders;
  Stream<List<Order>> assignments = WaiterController().assignments;

  // TAB SWITCHER
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: readyOrders,
      builder: (context, orders) {
        return StreamBuilder(
          stream: assignments,
          builder: (context, assignment) {
            final List<Widget> _children = [
              WaiterOrder(snapshot: orders),
              Text('Hesap Ödeme Talepleri'),
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
                    title: new Text('Hazır Siparişler'),
                  ),
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.attach_money),
                    title: new Text('Hesap Ödeme Talepleri'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.room_service),
                    title: Text('Servislerim'),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
