import 'package:sanal_menu/models/user.dart';
import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/views/shared/confirmation_popup.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/admin/admin_user_controller.dart';
import 'package:provider/provider.dart';

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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // USER INFORMATIONS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.name, style: Theme.of(context).textTheme.bodyText2),
                Text(user.role, style: Theme.of(context).textTheme.caption),
                Text(user.email, style: Theme.of(context).textTheme.caption),
              ],
            ),

            // RIGHT SIDE BUTTONS
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
                      String message = await AdminUserController().deleteUser(user.id);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(message),
                        backgroundColor: Theme.of(context).accentColor,
                      )); // display message about result
                    }
                  },
                ),
                // EDIT USER BUTTON
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Provider.of<AdminController>(context, listen: false).switchTabBody('AddEditUser'); // Switch tab.
                    Provider.of<AdminUserController>(context, listen: false).user = user; // Assign selected user values to controller variable.
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
