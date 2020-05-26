import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  labelStyle: TextStyle(color: Colors.black87, fontSize: 16),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 2.0)),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black45, width: 2.0)),
);

AppBar appBarAuth(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.settings),
      onPressed: null,
    ),
    title: Center(
      child: Text(
        'Sanal Menu',
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          AuthController().signOut();
          AuthController().signInAnonymously();
          Navigator.pushNamed(context, '/customer');
        },
      )
    ],
  );
}

AppBar appBarNonAuth(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.settings),
      onPressed: null,
    ),
    title: Center(
      child: Text(
        'Sanal Menu',
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.person),
        onPressed: () => Navigator.pushNamed(context, '/signin'),
      )
    ],
  );
}

// Circle to display on loading screen
Padding loadingCircle() {
  return Padding(
    padding: EdgeInsets.all(15),
    child: SpinKitRing(
      color: Colors.red[900],
      size: 40.0,
    ),
  );
}
