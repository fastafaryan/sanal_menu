import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/controllers/cook_controller.dart';
import 'package:sanal_menu/views/shared/order_tile.dart';

class CookOrderList extends StatelessWidget {
  final AsyncSnapshot snapshot;
  CookOrderList({this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot == null || snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Nothing to display.'),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Customer Orders",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () async {
                    final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationPopup(message: "Do you want to assign these orders to yourself?");
                        });
                    if (result == true) {
                      String result = await Provider.of<CookController>(context, listen: false).assignOrder();
                      // Display meesage based on result
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(result),
                        backgroundColor: Colors.green,
                      ));
                    }
                  }),
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
