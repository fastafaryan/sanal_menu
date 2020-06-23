import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:sanal_menu/models/item.dart';
import 'package:sanal_menu/views/customer/customer_home.dart';
import 'package:sanal_menu/views/login_director.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, currentUser) {
        print(currentUser);
        if (currentUser == null || currentUser.connectionState == ConnectionState.waiting || !currentUser.hasData) {
          print("[landing_page.dart] returning loadingCircle");
          return Scaffold(
            body: loadingCircle(messsage: "Checking authentication..."),
          );
        }
        if (currentUser.data.isAnonymous) {
          print("[landing_page.dart] returning customer_home.dart");
          return CustomerHome();
        }
        if (!currentUser.data.isAnonymous) {
          print("[landing_page.dart] returning landing_page.dart");
          return LoginDirector();
        }
        return Text("Error occured while checking authentication.");
      },
    );
  }

}
