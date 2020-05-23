import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/stream_service.dart';
import 'package:sanal_menu/views/customer/tabs/cart.dart';
import 'package:sanal_menu/views/customer/tabs/catalog.dart';
import 'package:sanal_menu/views/customer/tabs/orders.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:sanal_menu/controllers/auth_controller.dart';

class CustomerHome extends StatefulWidget {
  // Default construtor
  CustomerHome() {
    AuthController().signInAnonymously(); // Need to sign in at least anonymously to connect Firebase.
  }
  
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _currentIndex = 0;

  Stream<List<Item>> itemStream = StreamController().menuItems;
  Stream<List<Order>> cartStream = StreamController().userCartItems;
  Stream<List<Order>> orderStream = StreamController().userOrders;

  // TAB SWITCHER
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
                        BottomNavigationBarItem(icon: Icon(Icons.av_timer), title: Text('Orders'))
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
