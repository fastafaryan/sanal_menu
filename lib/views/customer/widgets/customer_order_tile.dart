import 'package:flutter/material.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/customer_controller.dart';
import 'package:sanal_menu/controllers/stream_controller.dart';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:sanal_menu/views/shared/constants.dart';

class CustomerOrderTile extends StatelessWidget {
  final Future<Order> orderFuture;

  CustomerOrderTile({this.orderFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: orderFuture,
      builder: (context, order) {
        if (order == null || order.data == null) {
          return loadingCircle();
        }

        Future<Item> itemFuture = StreamController().getItemByID(order.data.itemID);
        return FutureBuilder(
          future: itemFuture,
          builder: (context, item) {
            if (item == null || item.data == null) {
              return loadingCircle();
            }

            return Card(
              color: Colors.white,
              elevation: 2,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // Photo
                      Container(
                        width: 100,
                        height: 100,
                        child: AspectRatio(
                          aspectRatio: .1,
                          child: FittedBox(
                            child: Image.network(item.data.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(order.data.itemName, style: Theme.of(context).textTheme.bodyText1),
                          Text("Status: " + order.data.status, style: Theme.of(context).textTheme.caption),
                          Text("Assignee: " + order.data.assignee, style: Theme.of(context).textTheme.caption),
                          Text("Quantity: " + order.data.quantity.toString(), style: Theme.of(context).textTheme.caption),
                          Text("Total Price: " + "\$"+(order.data.itemPrice * order.data.quantity).toString(), style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                    ],
                  ),

                  // RIGHT SIDE OF THE TILE
                  Row(
                    children: <Widget>[
                      // CANCEL ORDER BUTTON. DISPLAYED IF ORDER IS NOT STARTED TO BEING PREPARED.
                      if (order.data.status == 'Ordered')
                        FlatButton(
                          child: Icon(Icons.delete_outline),
                          onPressed: () async {
                            final result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationPopup(message: "Do you wish to cancel?");
                                });
                            if (result == true) CustomerController().deleteOrder(order.data);
                          },
                        )
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
