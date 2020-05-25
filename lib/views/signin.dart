import 'package:sanal_menu/controllers/auth_controller.dart';
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
                    // header
                    Text(
                      'Sign in',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(height: 10),
                    // email
                    TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val.isEmpty ? 'email field is missing' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val.trim();
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    // password
                    TextFormField(
                      decoration: inputDecoration.copyWith(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val) {
                        setState(() {
                          password = val.trim();
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    // submit button
                    RaisedButton(
                      child: Text('Sign in', style: Theme.of(context).textTheme.button),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic user = await _auth.signInWithEmailAndPassword(email, password);

                          if (user == null) {
                            setState(() {
                              error = 'Wrong credentials!';
                            });
                          } else {
                            Navigator.pushReplacementNamed(context, '/landingPage');
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
