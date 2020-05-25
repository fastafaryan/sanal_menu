import 'package:flutter/material.dart';
import 'package:sanal_menu/views/customer/widgets/customer_order_tile.dart';

class OrdersView extends StatelessWidget {
  AsyncSnapshot snapshot;
  OrdersView({this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Nothing to diplay.'),
      );
    }

    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (_, int index) {
        //return Text("Order Item");
        return CustomerOrderTile(order: snapshot.data[index]);
      },
    );
  }
}
