import 'package:flutter/material.dart';
import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:sanal_menu/views/customer/customer_home.dart';
import 'package:sanal_menu/views/landing_page.dart';
import 'package:sanal_menu/views/login_director.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Launch extends StatefulWidget {
  @override
  _LaunchState createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  @override
  void initState() {
    AuthController().signOut();
    AuthController().signInAnonymously();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LandingPage();
  }
}
