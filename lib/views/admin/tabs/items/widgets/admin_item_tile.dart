import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/controllers/admin/admin_item_controller.dart';

class AdminItemTile extends StatelessWidget {
  Item item;
  AdminItemTile({this.item});

  @override
  Widget build(BuildContext context) {
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
                    child: Image.network(item.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  header2(item.name),
                  Text(item.price.toString() +  ' \$'),
                ],
              ),
            ],
          ),

          // RIGHT SIDE OF THE TILE
          Row(
            children: <Widget>[
              // DELETE ITEM BUTTON
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () async {
                  // Show a popup for action confirmation
                  final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationPopup(message: "Do you wish to delete this item?");
                      });
                  // If click on yes delete
                  if (result == true) {
                    String message = Provider.of<AdminItemController>(context, listen: false).deleteItem(item);
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message) ,backgroundColor: Colors.red[900],));
                  }
                },
              ),

              // EDIT ITEM BUTTON
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Provider.of<AdminController>(context, listen: false).switchTabBody('AddEditItem');
                  Provider.of<AdminItemController>(context, listen: false).setItem(item);
                  Provider.of<AdminItemController>(context, listen: false).setImageFile(null);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
