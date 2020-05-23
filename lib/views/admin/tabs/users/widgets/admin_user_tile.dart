import 'package:sanal_menu/models/user.dart';
import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:flutter/material.dart';

class AdminUserTile extends StatelessWidget {
  User user;
  AdminUserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  header2(user.name),
                  Text(user.email),
                ],
              ),
            ),
            SizedBox(width: 50),
            Text(user.role),
            Spacer(),
            Row(
              children: <Widget>[
                // DELETE USER BUTTON
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () async {
                    // Show a popup for action confirmation
                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationPopup(message: "Do you wish to delete?");
                      },
                    );
                    // If clicked on yes button then delete
                    if (result == true) {
                      String message = AdminController().deleteUser(user.id);
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message))); // display message about result
                    }
                  },
                ),
                // EDIT USER BUTTON
                IconButton(icon: Icon(Icons.edit), onPressed: null),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
