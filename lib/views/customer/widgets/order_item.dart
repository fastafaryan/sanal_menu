import 'package:flutter/material.dart';
import 'package:sanal_menu/models/order.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/controllers/customer_controller.dart';
import 'package:sanal_menu/controllers/stream_service.dart';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  OrderItem({this.order});

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
                  Text(order.status),
                  Text(order.assignnee),
                  FlatButton(
                    child: Icon(Icons.cancel),
                    onPressed: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationPopup(message: "Şiparişi iptal etmek üzeresiniz. Bunu yapmak istediğinize emin misiniz?");
                          });
                      if (result == true) CustomerController().cancelOrder(order);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
