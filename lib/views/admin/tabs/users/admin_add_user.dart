import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AdminAddUser extends StatefulWidget {
  @override
  _AdminAddUserState createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String role = 'Admin';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Provider.of<AdminController>(context, listen: false).switchTabBody('Users'),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Add New User",
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  // NAME
                  TextFormField(
                    decoration: inputDecoration.copyWith(labelText: "Full name"),
                    onChanged: (val) {
                      name = val;
                    },
                  ),
                  SizedBox(height: 10),
                  // EMAIL
                  TextFormField(
                    decoration: inputDecoration.copyWith(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val.isEmpty ? 'email field is missing' : null,
                    onChanged: (val) {
                      email = val.trim();
                    },
                  ),
                  SizedBox(height: 10),
                  // PASSWORD
                  TextFormField(
                    decoration: inputDecoration.copyWith(labelText: "Password"),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                    onChanged: (val) {
                      password = val;
                    },
                  ),
                  SizedBox(height: 10),
                  // ROLE
                  DropdownButton<String>(
                    isExpanded: true,
                    value: role,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 8,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        role = newValue;
                      });
                    },
                    items: <String>['Admin', 'Garson', 'Mutfak'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  // SUBMIT
                  RaisedButton(
                    child: Text('Add', style: Theme.of(context).textTheme.button),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String result = await AdminController().addUser(email: email, pwd: password, name: name, role: role);
                        // Switch tab body back to list.
                        Provider.of<AdminController>(context, listen: false).switchTabBody('Users');
                        // Display meesage based on result
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(result),
                          backgroundColor: Colors.green,
                        ));
                      }
                    },
                    //
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
