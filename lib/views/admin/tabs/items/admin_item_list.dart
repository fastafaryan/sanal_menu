import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/controllers/admin/admin_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/admin/tabs/items/widgets/admin_item_tile.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:provider/provider.dart';

class AdminItemList extends StatelessWidget {
  AsyncSnapshot snapshot;
  AdminItemList({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal:10, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Items", style: Theme.of(context).textTheme.subtitle1),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Provider.of<AdminController>(context, listen: false).switchTabBody('AddEditItem');
                    Provider.of<AdminItemController>(context, listen: false).setItem(null);
                    Provider.of<AdminItemController>(context, listen: false).setImageFile(null);
                  }),
            ],
          ),
        ),
        (snapshot == null || snapshot.data == null || snapshot.data.length == 0)
            ? Center(
                child: Text('Nothing to display.'),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, int index) {
                    return AdminItemTile(item: snapshot.data[index]);
                  },
                ),
              ),
      ],
    );
  }
}
