import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/stream_service.dart';
import 'package:sanal_menu/views/shared/modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CartItem extends StatelessWidget {
  final Order order;

  CartItem({this.order});

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
            elevation: 5,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(5),
              height: 150,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: FittedBox(
                      child: Image.network(i.data.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(i.data.name, style: TextStyle(fontSize: 20)),
                  Modifier(item: i.data),
                ],
              ),
            ),
          );
        });
  }
}
