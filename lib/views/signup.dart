import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthController _auth = AuthController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarNonAuth(context),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Kayıt Ol', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  decoration: inputDecoration.copyWith(labelText: 'Email'),
                  validator: (val) => val.isEmpty ? 'email field is missing' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val.trim();
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: inputDecoration.copyWith(labelText: 'Şifre'),
                  obscureText: true,
                  validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() {
                      password = val.trim();
                    });
                  },
                ),
                SizedBox(height: 10),
                RaisedButton(
                  child: Text('Kayıt Ol'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);

                      if (result == null) {
                        setState(() {
                          error = 'Credentials are wrong!';
                        });
                      } else {
                        print(result);
                        Navigator.pushReplacementNamed(context, '/catalog');
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),
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
