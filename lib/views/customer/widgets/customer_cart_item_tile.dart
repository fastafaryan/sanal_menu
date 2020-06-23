import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/stream_controller.dart_';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:sanal_menu/views/shared/modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomerCartItemTile extends StatelessWidget {
  final Future<Order> orderFuture;

  CustomerCartItemTile({this.orderFuture});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orderFuture,
        builder: (context, order) {
          if (order == null || order.data == null) {
            return loadingCircle();
          }
          Future<Item> itemFuture = BaseController().getItemByID(order.data.itemID);
          return FutureBuilder(
            future: itemFuture,
            builder: (context, item) {
              if (item == null || item.data == null) {
                if (item.connectionState == ConnectionState.waiting) {
                  return loadingCircle();
                }

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
                              child: Image.network(item.data.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(item.data.name, style: Theme.of(context).textTheme.bodyText1),
                            Text("Price: " + "\$" + item.data.price.toString(), style: Theme.of(context).textTheme.bodyText2),
                          ],
                        ),
                      ],
                    ),

                    // RIGHT SIDE OF THE TILE
                    Row(
                      children: <Widget>[
                        Modifier(item: item.data),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
