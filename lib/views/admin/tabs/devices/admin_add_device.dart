import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:flutter/material.dart';

class AdminAddDevice extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                    child: Text('Register', style: Theme.of(context).textTheme.button,),
                    onPressed: () async {
                      String result = await AdminController().addDevice(name); // call addDevice function from controller
                      AdminController().switchTabBody('Devices');
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(result),
                        backgroundColor: Colors.green,
                      )); // display message about result
                    }),
                SizedBox(height: 12),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                )
              ],
            ),
          )),
    );
  }
}
