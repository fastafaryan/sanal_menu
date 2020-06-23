import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:sanal_menu/models/user.dart';
import 'package:sanal_menu/views/admin/admin_home.dart';
import 'package:sanal_menu/views/cook/cook_home.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:sanal_menu/views/waiter/waiter_home.dart';

class LoginDirector extends StatelessWidget {
  final Stream<List<User>> roleStream = AuthController().checkUserRole;

  @override
  Widget build(BuildContext context) {
    //if (roleStream == null) return Center(child: Text('Please wait.'));

    return WillPopScope(
      child: StreamBuilder(
        stream: roleStream,
        builder: (context, role) {
          if (role.data == null || role.data.length == 0) {
            return Scaffold(
              body: loadingCircle(
                  messsage: "Checking authenticated user role..."),
            );
          }

          if (role.data[0].role == 'Admin') return AdminHome();
          if (role.data[0].role == 'Garson') return WaiterHome();
          if (role.data[0].role == 'Mutfak') return CookHome();
          return Text(role.data[0].role);
        },
      ),
      onWillPop: () async => false,
    );
  }
}
