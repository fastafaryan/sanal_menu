import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/views/customer/tabs/cart.dart';
import 'package:sanal_menu/views/customer/tabs/catalog.dart';
import 'package:sanal_menu/views/customer/tabs/orders.dart';
import 'package:sanal_menu/controllers/stream_controller.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/shared/constants.dart';

class CustomerHome extends StatefulWidget {
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _currentIndex = 0;

  // TAB SWITCHER
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Stream<List<Item>> itemStream = StreamController().menuItems;
  Stream<List<Future<Order>>> cartStream = StreamController().userCartItems;
  Stream<List<Future<Order>>> orderStream = StreamController().userOrders;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: itemStream,
      builder: (context, items) {
        return StreamBuilder(
            stream: cartStream,
            builder: (context, cartItem) {
              return StreamBuilder(
                stream: orderStream,
                builder: (context, orders) {
                  final List<Widget> _children = [Catalog(snapshot: items), Cart(snapshot: cartItem), OrdersView(snapshot: orders)];
                  return Scaffold(
                    appBar: appBarNonAuth(context),
                    body: _children[_currentIndex],
                    bottomNavigationBar: BottomNavigationBar(
                      onTap: onTabTapped,
                      currentIndex: _currentIndex,
                      items: [
                        BottomNavigationBarItem(
                          icon: new Icon(Icons.local_dining),
                          title: new Text('Catalog'),
                        ),
                        BottomNavigationBarItem(
                          icon: new Icon(Icons.shopping_basket),
                          title: new Text('Cart'),
                        ),
                        BottomNavigationBarItem(
                          icon: Stack(
                            children: <Widget>[
                              Icon(Icons.ac_unit),
                              Positioned(
                                right: 0.0,
                                child: Icon(Icons.brightness_1, size: 10.0, color: Colors.red[900]),
                              )
                            ],
                          ),
                          title: Text('Orders'),
                        )
                      ],
                    ),
                  );
                },
              );
            });
      },
    );
  }
}
