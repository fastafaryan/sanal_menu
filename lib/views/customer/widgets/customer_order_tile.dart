import 'package:flutter/material.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/customer_controller.dart';
import 'package:sanal_menu/controllers/stream_controller.dart';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';

class CustomerOrderTile extends StatelessWidget {
  final Order order;

  CustomerOrderTile({this.order});

  @override
  Widget build(BuildContext context) {
    Future<Item> item = StreamController().getItemByID(order.itemID);

    return FutureBuilder(
        future: item,
        builder: (context, i) {
          if (i == null || i.data == null) {
            return Center(child: Text("Item not found!"));
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
                      width: 75,
                      height: 75,
                      child: AspectRatio(
                        aspectRatio: .1,
                        child: FittedBox(
                          child: Image.network(i.data.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(i.data.name, style: Theme.of(context).textTheme.bodyText1),
                        Text("Status: " + order.status, style: Theme.of(context).textTheme.bodyText2),
                        Text("Assignee: " + order.assignee, style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                  ],
                ),

                // RIGHT SIDE OF THE TILE
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.delete_outline),
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationPopup(message: "Do you wish to cancel?");
                            });
                        if (result == true) CustomerController().deleteOrder(order);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
