import 'package:sanal_menu/controllers/waiter_controller.dart';
import 'package:sanal_menu/views/shared/order_tile.dart';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaiterAssignments extends StatelessWidget {
  final AsyncSnapshot snapshot; // presents Order model
  WaiterAssignments({this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot == null || snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Nothing to display.'),
      );
    }

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Siparişler',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Row(
                  children: <Widget>[
                    // Release button
                    IconButton(
                      icon: Icon(Icons.settings_backup_restore),
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationPopup(message: "Do you want to release these orders?");
                            });
                        if (result == true) {
                          String result = Provider.of<WaiterController>(context, listen: false).releaseAssignments();
                          // Display meesage based on result
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                    // Done button
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationPopup(message: "Seçili siparişleri teslim edildi olarak güncellemek istediğinize emin misiniz?");
                            });
                        if (result == true) Provider.of<WaiterController>(context, listen: false).setAsServed();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return OrderTile(orderFuture: snapshot.data[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
