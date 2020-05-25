import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:sanal_menu/views/admin/tabs/users/widgets/admin_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUserList extends StatelessWidget {
  AsyncSnapshot snapshot;
  AdminUserList({this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot == null || snapshot.data == null || snapshot.data.length == 0) {
      return Center(
        child: Text('Nothing to display!'),
      );
    }
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal:10, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Users", style: Theme.of(context).textTheme.subtitle1),
              // ADD USER BUTTON
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.add),
                onPressed: () => Provider.of<AdminController>(context,listen: false).switchTabBody('AddUser'),
              ),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, int index) {
            return AdminUserTile(user: snapshot.data[index]);
          },
        ))
      ],
    );
  }
}
