import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/controllers/cook_controller.dart';
import 'package:sanal_menu/views/shared/order_tile.dart';

class CookOrders extends StatelessWidget {
  final AsyncSnapshot snapshot;
  CookOrders({this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot == null || snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Sipariş bulunmuyor.'),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Siparişler",
                style: TextStyle(fontSize: 25),
              ),
              RaisedButton(
                child: Icon(Icons.done),
                onPressed: () async {
                  final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationPopup(message: "Seçili siparişleri hazır olarak işaretlemeye emin misiniz?");
                      });
                  if (result == true) Provider.of<CookController>(context, listen: false).assignOrder();
                }
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderTile(order: snapshot.data[index]);
            },
          ),
        ),
      ],
    );
  }
}
