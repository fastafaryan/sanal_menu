import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/models/user.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:sanal_menu/controllers/base_controller.dart';
import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/controllers/admin/admin_user_controller.dart';

class AdminAddEditUser extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Receive user value from provider.
    User user = Provider.of<AdminUserController>(context).user;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          // HEADER START
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_backspace),
                onPressed: () => Provider.of<AdminController>(context, listen: false).switchTabBody('Users'),
                iconSize: 15,
              ),
              Text(
                "Add/Edit User",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          // HEADER END

          // FORM CONTENT START
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                // NAME
                TextFormField(
                  initialValue: user != null ? user.name : '',
                  decoration: inputDecoration.copyWith(labelText: "Full name"),
                  onChanged: (val) {
                    Provider.of<AdminUserController>(context, listen: false).setName(val);
                  },
                ),
                SizedBox(height: 10),

                // EMAIL
                TextFormField(
                  initialValue: user != null ? user.email : '',
                  decoration: inputDecoration.copyWith(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val.isEmpty ? 'email field is missing' : null,
                  onChanged: (val) {
                    Provider.of<AdminUserController>(context, listen: false).setEmail(val);
                  },
                ),

                // ROLE
                DropdownButton<String>(
                  hint:  Text("Select role"),
                  isExpanded: true,
                  value: user != null ? user.role : '',
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 8,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String val) {
                    Provider.of<AdminUserController>(context, listen: false).setRole(val);
                  },
                  items: <String>['Admin', 'Garson', 'Mutfak'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // SUBMIT
                RaisedButton(
                  child: Text('Submit', style: Theme.of(context).textTheme.button),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      FunctionFeedback feedback = await Provider.of<AdminUserController>(context, listen: false).addEditUser();
                      if (feedback.type == MessageTypes.success) Provider.of<AdminController>(context, listen: false).switchTabBody('Users');
                      displayMessage(context, feedback);
                    }
                  },
                ),
              ],
            ),
          ),
          // FORM CONTENT END
        ]),
      ),
    );
  }
}
