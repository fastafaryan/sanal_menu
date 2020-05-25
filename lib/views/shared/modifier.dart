import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/customer_controller.dart';
import 'package:sanal_menu/controllers/stream_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Modifier extends StatelessWidget {
  final Item item;
  Modifier({this.item});

  @override
  Widget build(BuildContext context) {
    Stream<List<Order>> order = StreamController().getOrderByItem(item.id);

    return StreamBuilder(
      stream: order,
      builder: (context, o) {
        // CHECK IF ANY DATA EXIST IN THE STREAM. IF IT DOES NOT EXIST THAT MEANS USER HAS NOT ORDERED FROM THIS ITEM BEFORE
        if (o.data == null || o.data.length == 0) {
          // CHECK IF DATA IS LOADED OR NOT
          if (o.connectionState == ConnectionState.waiting) {
            return SpinKitRing(
              color: Colors.black,
              size: 50.0,
            );
          }

          return Column(
            children: <Widget>[
              Text(item.price.toString() + " ₺", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              RaisedButton(
                child: Text('Sipariş ver', style: Theme.of(context).textTheme.button),
                onPressed: () => CustomerController().addToCart(item.id),
              ),
            ],
          );
        }

        // IF ORDER EXIST IN DB DISPLAY BELOW
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // MODIFIER
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => CustomerController().modifyOrder(o.data[0], o.data[0].quantity - 1),
                ),
                Text(o.data[0].quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => CustomerController().modifyOrder(o.data[0], o.data[0].quantity + 1),
                ),
              ],
            ),

            // DYNAMIC PRICE DISPLAY
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text("Total price: \$" + (item.price * o.data[0].quantity).toString()),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
