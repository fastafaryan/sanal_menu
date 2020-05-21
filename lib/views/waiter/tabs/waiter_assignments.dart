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
        child: Text('Sipariş bulunmuyor.'),
      );
    }

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Siparişler', style: TextStyle(fontSize: 20),),
                RaisedButton(
                  child: Icon(Icons.done),
                 onPressed: () async {
                  final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationPopup(message: "Seçili siparişleri teslim edildi olarak güncellemek istediğinize emin misiniz?");
                      });
                  if (result == true) Provider.of<WaiterController>(context, listen: false).setAsServed();
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
      ),
    );
  }
}
