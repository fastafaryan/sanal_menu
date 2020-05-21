import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/controllers/waiter_controller.dart';
import 'package:sanal_menu/controllers/cook_controller.dart';

/*
Displays Order with its name, quantity as well as a checkbox on the right side.
Currently used inside below classes. 
- CookOrders
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
                          Text(order.name),
                          Text(order.deviceID),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(order.quantity.toString() + " adet"),
                          Text("Sipariş zamanı: " + order.getCreationTime()),
                        ],
                      ),
                    ],
                  ),
                  //subtitle: Text(order.creationTime.toString()),
                  //subtitle: Text(order.quantity.toString() + " adet"),
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
