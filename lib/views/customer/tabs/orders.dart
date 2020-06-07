import 'package:flutter/material.dart';
import 'package:sanal_menu/views/customer/widgets/order_summary.dart';
import 'package:sanal_menu/views/customer/widgets/customer_order_tile.dart';

class OrdersView extends StatelessWidget {
  final  AsyncSnapshot snapshot;
  OrdersView({this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Nothing to diplay.'),
      );
    }

    return Container(
      child: Column(
        children: <Widget>[
          OrderSummary(snapshot: snapshot),
          Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, int index) {
                return CustomerOrderTile(orderFuture: snapshot.data[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
