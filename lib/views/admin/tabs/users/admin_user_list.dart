import 'file:///D:/Documents/Programming/sanal_menu/lib/controllers/admin/admin_controller.dart';
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
        child: Text('Görüntülenecek bir şey yok!'),
      );
    }
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              header1("Kullanıcılar"),
              // ADD USER BUTTON
              IconButton(
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
