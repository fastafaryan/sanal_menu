import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/stream_controller.dart';
import 'package:sanal_menu/views/cook/tabs/cook_assignments.dart';
import 'package:sanal_menu/views/cook/tabs/cook_order_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sanal_menu/views/shared/constants.dart';

class CookHome extends StatefulWidget {
  @override
  _CookHomeState createState() => _CookHomeState();
}

class _CookHomeState extends State<CookHome> {
  int _currentIndex = 0;
  Stream<List<Order>> ordersStream = StreamController().allOrders;
  Stream<List<Order>> assignments = StreamController().cookAssignments;

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
              stream: assignments,
              builder: (context, assignment) {
                final List<Widget> _children = [
                  CookOrderList(snapshot: orders),
                  CookAssignment(snapshot: assignment),
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
                        title: new Text('Customer Orders'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.room_service),
                        title: Text('My Assignments'),
                      ),
                      
                    ],
                  ),
                );
              });
        });
  }
}
