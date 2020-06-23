import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sanal_menu/controllers/base_controller.dart';

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
      // SIGN OUT BUTTOM
      IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          print("[constants.dart] Signin out...");
          AuthController().signOut().then((value) {
            AuthController().signInAnonymously();
          });
          //Navigator.pushNamed(context, '/landing_page');
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
Widget loadingCircle({String messsage}) {
  return Padding(
    padding: EdgeInsets.all(15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitRing(
          color: Colors.red[900],
          size: 40.0,
        ),
        SizedBox(height: 10),
        messsage != null ? Text(messsage) : Text("Loading"),
      ],
    ),
  );
}

dynamic displayMessage(BuildContext context, FunctionFeedback feedback) {
  if (feedback.type == MessageTypes.success)
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(feedback.message),
      backgroundColor: Colors.green,
    ));
  if (feedback.type == MessageTypes.error)
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(feedback.message),
      backgroundColor: Colors.red[900],
    ));
  if (feedback.type == MessageTypes.warning)
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(feedback.message),
      backgroundColor: Colors.amber[600],
    ));
  if (feedback.type == MessageTypes.info)
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(feedback.message),
      backgroundColor: Colors.grey[900],
    ));
}

Widget customIcon(IconData iconData) {
  return Stack(
    children: <Widget>[
      Icon(iconData),
      Positioned(
        right: 0.0,
        child: Icon(Icons.brightness_1, size: 10.0, color: Colors.red[900]),
      )
    ],
  );
}
