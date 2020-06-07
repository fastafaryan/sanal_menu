import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/waiter_controller.dart';
import 'package:sanal_menu/controllers/cook_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';

/*
Displays Order with its name, quantity as well as a checkbox on the right side.
Currently used inside below classes. 
- CookOrderList
- CookAssignmets
- WaiterOrders
- WaiterAssignments
*/

class OrderTile extends StatelessWidget {
  final Future<Order> orderFuture;
  OrderTile({@required this.orderFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orderFuture,
        builder: (context, order) {
          if (order == null || order.data == null) return loadingCircle();
          return Card(
            child: Consumer<CookController>(
              builder: (context, cookController, child) {
                return Consumer<WaiterController>(
                  builder: (context, waiterController, child) {
                    return CheckboxListTile(
                        title: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(order.data.itemName, style: Theme.of(context).textTheme.bodyText2),
                                Text(order.data.deviceName, style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(order.data.quantity.toString() + " adet", style: Theme.of(context).textTheme.caption),
                                Text("Order time: " + order.data.getCreationTime(), style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                          ],
                        ),
                        value: order.data.isSelected,
                        onChanged: (bool value) {
                          // Check order status to call correct funciton
                          if (order.data.status == 'Ordered' || order.data.status == 'Preparing')
                            Provider.of<CookController>(context, listen: false).toggleSelection(order.data);
                          if (order.data.status == 'Ready' || order.data.status == 'Serving')
                            Provider.of<WaiterController>(context, listen: false).toggleSelection(order.data);
                        });
                  },
                );
              },
            ),
          );
        });
  }
}
