import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/controllers/base_controller.dart';

class AdminAddDevice extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Body Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Provider.of<AdminController>(context, listen: false).switchTabBody('Devices'),
                ),
                SizedBox(width: 20),
                Text(
                  "Add Device",
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
          ),
          // Body content
          Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text("You can register a device to system from this tab. Just enter what this device's display name will be."),
                  SizedBox(height: 20),
                  // NAME
                  TextFormField(
                    decoration: inputDecoration.copyWith(labelText: "Display name"),
                    onChanged: (val) {
                      name = val;
                    },
                  ),
                  SizedBox(height: 12),
                  RaisedButton(
                      child: Text(
                        'Register',
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () async {
                        Map result = await AdminController().addDevice(name); // call addDevice function from controller

                        if (result['type'] == MessageTypes.error) {
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.red));
                        } else if (result['type'] == MessageTypes.success) {
                          Provider.of<AdminController>(context, listen: false).switchTabBody('Devices');
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(result['message']), backgroundColor: Colors.green));
                        }
                      }),
                  SizedBox(height: 12),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
