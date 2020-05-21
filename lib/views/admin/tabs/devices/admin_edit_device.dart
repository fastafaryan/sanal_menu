import 'package:sanal_menu/models/device.dart';
import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:sanal_menu/views/shared/constants.dart';

class AdminEditDevice extends StatelessWidget {
  final Device device;
  AdminEditDevice({this.device});

  final _formKey = GlobalKey<FormState>();
  String name = '';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100, minWidth: 500),
            child: Container(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Cihaz Adını Güncelle",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: inputDecoration.copyWith(labelText: "Cihazın adı"),
                          onChanged: (val) {
                            name = val;
                          },
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                          child: Text('Güncelle'),
                          onPressed: () async {
                            String result = await AdminController().editDeviceName(device.id, name); // call addDevice function from controller
                            Navigator.of(context, rootNavigator: true).pop(result);
                            return result;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
