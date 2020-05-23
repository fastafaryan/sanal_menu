import 'package:flutter/material.dart';

class ConfirmationPopup extends StatelessWidget {
  final String message;
  ConfirmationPopup({this.message});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        width: 400,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(message),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('No'),
                ),
                SizedBox(width: 15),
                RaisedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Yes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
