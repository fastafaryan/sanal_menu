import 'package:flutter/material.dart';
import 'package:sanal_menu/views/customer/widgets/order_item.dart';

class OrdersView extends StatelessWidget {
  AsyncSnapshot snapshot;
  OrdersView({this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot.data == null) {
      return Center(
        child: Text('Henüz bir şipariş vermediniz.'),
      );
    }

    return snapshot.data.length > 0
        ? ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, int index) {
              //return Text("Order Item");
              return OrderItem(order: snapshot.data[index]);
            },
          )
        : Center(
            child: Text('Henüz bir şipariş vermediniz.'),
          );
  }
}
