import 'package:sanal_menu/models/user.dart';
import 'package:sanal_menu/controllers/auth_controller.dart';
import 'package:sanal_menu/controllers/stream_service.dart';
import 'package:sanal_menu/views/shared/constants.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthController _auth = AuthController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarNonAuth(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text('Yönetici Girişi',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Email'),
                      validator: (val) =>
                          val.isEmpty ? 'email field is missing' : null,
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
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          password = val.trim();
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text('Giriş Yap'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic user = await _auth.signInWithEmailAndPassword(
                              email, password);

                          if (user == null) {
                            setState(() {
                              error = 'Giriş bilgileri yanlış!';
                            });
                          } else {
                            Navigator.pushReplacementNamed(
                                context, '/landingPage');
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
        ],
      ),
    );
  }
}
//admin@sanalmenu.com
