import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/stream_controller.dart';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:sanal_menu/views/shared/modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomerCartItemTile extends StatelessWidget {
  final Order order;

  CustomerCartItemTile({this.order});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Item> item = StreamController().getItemByID(order.itemID);

    return FutureBuilder(
      future: item,
      builder: (context, i) {
        if (i == null || i.data == null) {
          if (i.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.all(30),
              child: SpinKitRing(
                color: Colors.black,
                size: 50.0,
              ),
            );
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
                      Text("Price: " + "\$" + i.data.price.toString(), style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ],
              ),

              // RIGHT SIDE OF THE TILE
              Row(
                children: <Widget>[
                  Modifier(item: i.data),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
