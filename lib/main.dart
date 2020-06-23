import 'package:sanal_menu/controllers/admin/admin_controller.dart';
import 'package:sanal_menu/controllers/admin/admin_item_controller.dart';
import 'package:sanal_menu/controllers/admin/admin_user_controller.dart';
import 'package:sanal_menu/controllers/cook_controller.dart';
import 'package:sanal_menu/controllers/customer_controller.dart';
import 'package:sanal_menu/controllers/waiter/waiter_payments_controller.dart';
import 'package:sanal_menu/controllers/waiter_controller.dart';
import 'package:sanal_menu/views/admin/admin_home.dart';
import 'package:sanal_menu/views/customer/customer_home.dart';
import 'package:sanal_menu/views/cook/cook_home.dart';
import 'package:sanal_menu/views/landing_page.dart';
import 'package:sanal_menu/views/launch.dart';
import 'package:sanal_menu/views/signin.dart';
import 'package:sanal_menu/views/signup.dart';
import 'package:sanal_menu/views/test.dart';
import 'package:sanal_menu/views/waiter/waiter_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => LandingPage()),
        ListenableProvider(create: (context) => CookController()),
        ListenableProvider(create: (context) => WaiterController()),
        ChangeNotifierProvider(create: (context) => AdminController()),
        ChangeNotifierProvider(create: (context) => CustomerController()),
        ChangeNotifierProvider(create: (context) => AdminItemController()),
        ChangeNotifierProvider(create: (context) => AdminUserController()),
        ChangeNotifierProvider(create: (context) => WaiterPaymentsController()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.red[900],
          accentColor: Colors.red[900],
          buttonColor: Colors.red[900],
          textTheme: TextTheme(
            button: TextStyle(color: Colors.white),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.red[900],
            highlightColor: Colors.red,
          ),
          scaffoldBackgroundColor: Colors.grey[200],
        ),
        title: 'Sanal Menu',
        initialRoute: '/launch',
        routes: <String, WidgetBuilder>{
          "/launch": (BuildContext context) => new Launch(),
          "/landing_page": (BuildContext context) => new LandingPage(),
          "/customer": (BuildContext context) => new CustomerHome(),
          "/kitchen": (BuildContext context) => new CookHome(),
          "/waiter": (BuildContext context) => WaiterHome(),
          "/admin": (BuildContext context) => new AdminHome(),
          "/signup": (BuildContext context) => new SignUp(),
          "/signin": (BuildContext context) => new SignIn(),
          "/test": (BuildContext context) => new Test(),
          //add more routes here
        },
      ),
    );
  }
}
