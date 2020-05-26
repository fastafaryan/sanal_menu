import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/waiter_controller.dart';
import 'package:sanal_menu/controllers/cook_controller.dart';

/*
Displays Order with its name, quantity as well as a checkbox on the right side.
Currently used inside below classes. 
- CookOrderList
- CookAssignmets
- WaiterOrders
- WaiterAssignments
*/

class OrderTile extends StatelessWidget {
  final Order order;
  OrderTile({@required this.order});

  @override
  Widget build(BuildContext context) {
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
                          Text(order.name, style: Theme.of(context).textTheme.bodyText2),
                          Text(order.deviceName, style: Theme.of(context).textTheme.bodyText2),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(order.quantity.toString() + " adet", style: Theme.of(context).textTheme.caption),
                          Text("Order time: " + order.getCreationTime(), style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                    ],
                  ),
                  value: order.isSelected,
                  onChanged: (bool value) {
                    // Check order status to call correct funciton
                    if (order.status == 'Ordered' || order.status == 'Preparing')
                      Provider.of<CookController>(context, listen: false).toggleSelection(order);
                    if (order.status == 'Ready' || order.status == 'Serving')
                      Provider.of<WaiterController>(context, listen: false).toggleSelection(order);
                  });
            },
          );
        },
      ),
    );
  }
}