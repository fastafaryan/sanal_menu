import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/customer_controller.dart';
import 'package:sanal_menu/controllers/stream_controller.dart_';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/shared/constants.dart';

class Modifier extends StatelessWidget {
  final Item item;
  Modifier({this.item});

  @override
  Widget build(BuildContext context) {
    Stream<List<Future<Order>>> orderStream = CustomerController().getOrderByItemID(item.id);
    return StreamBuilder(
      stream: orderStream,
      builder: (context, orderFuture) {
        if (orderFuture == null || orderFuture.data == null || orderFuture.data.length == 0) {
          return Column(
            children: <Widget>[
              Text(item.price.toString() + " ₺", style: Theme.of(context).textTheme.subtitle2),
              RaisedButton(
                child: Text('Order', style: Theme.of(context).textTheme.button),
                onPressed: () => CustomerController().addToCart(item.id),
              ),
            ],
          );
        }

        return FutureBuilder(
          future: orderFuture.data[0],
          builder: (context, order) {
            if (order == null || order.data == null) {
              return loadingCircle();
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
                      onPressed: () => CustomerController().modifyOrder(order.data, order.data.quantity - 1),
                    ),
                    Text(order.data.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => CustomerController().modifyOrder(order.data, order.data.quantity + 1),
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
                      child: Text("Total price: \$" + (item.price * order.data.quantity).toString()),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
/*
switch (order.connectionState) {
          case ConnectionState.waiting:
            return loadingCircle();
          default:
            if (order == null || order.data == null) {
              
            } else if (order.hasError)
              return Text('Error: ${order.error}');
            else {
              
            }
        }*/
