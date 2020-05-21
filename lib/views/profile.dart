import 'package:sanal_menu/views/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      user = arguments['user'];
      print(user);
    }

    return Scaffold(
      appBar: appBarNonAuth(context),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        child: Text(user.email+user.uid),
      ),
    );
  }
}
