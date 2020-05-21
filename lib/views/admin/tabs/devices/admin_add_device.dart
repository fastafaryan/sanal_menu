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
                Text(
                    'Bu sekme üzerinden bu cihaza sipariş verme yetkilendirmesi yapabilirsiniz. Aşağıda bulunan alana sistemde bu cihazın adının ne olarak görüntüleceğini belirtiniz. Örn: Masa 1'),
                SizedBox(height: 20),
                // NAME
                TextFormField(
                  decoration: inputDecoration.copyWith(labelText: "Cihazın adı"),
                  onChanged: (val) {
                    name = val;
                  },
                ),
                SizedBox(height: 12),
                RaisedButton(
                    child: Text('Yetkilendir'),
                    onPressed: () async {
                      String result = await AdminController().addDevice(name); // call addDevice function from controller
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(result))); // display message about result
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
