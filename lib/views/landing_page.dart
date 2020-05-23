import 'package:sanal_menu/models/user.dart';
import 'package:sanal_menu/controllers/stream_controller.dart';
import 'package:sanal_menu/views/admin/admin_home.dart';
import 'package:sanal_menu/views/cook/cook_home.dart';
import 'package:sanal_menu/views/waiter/waiter_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LandingPage extends StatelessWidget {
  final Stream<List<User>> roleStream = StreamController().checkUserRole;

  @override
  Widget build(BuildContext context) {
    //if (roleStream == null) return Center(child: Text('Lütfen bekleyiniz.'));

    return WillPopScope(
      child: StreamBuilder(
        stream: roleStream,
        builder: (context, role) {
          if (role.data == null || role.data.length == 0) {
            return SpinKitRing(
              color: Colors.black,
              size: 50.0,
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
