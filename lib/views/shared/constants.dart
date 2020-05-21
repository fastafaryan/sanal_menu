import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

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
        'Sanal Menü',
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          AuthController().signOut();
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
        'Sanal Menü',
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

Text header1(String str) {
  return Text(str, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.5),);
}

Text header2(String str) {
  return Text(str, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),);
}
