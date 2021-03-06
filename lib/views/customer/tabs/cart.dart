import 'package:sanal_menu/controllers/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/customer/widgets/customer_cart_item_tile.dart';

class Cart extends StatelessWidget {
  AsyncSnapshot snapshot;
  Cart({this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Nothing to display.'),
      );
    }

    return Container(
      child: Column(
        children: <Widget>[
          // HEADER
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => CustomerController().completeOrders(snapshot.data),
                  child: Text("Confirm order", style: Theme.of(context).textTheme.button),
                  elevation: 0,
                ),
              ],
            ),
          ),

          // CART ITEMS
          Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, int index) {
                return CustomerCartItemTile(orderFuture: snapshot.data[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
