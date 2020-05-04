import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wt_dc_app/models/user_model.dart';
import 'package:wt_dc_app/screens/auth_screen.dart';
import 'package:wt_dc_app/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Scaffold homeScreen = Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: HomeScreen(),
    );
    String email;
    String password;
    var userObj = User('', '', false);
    SharedPreferences.getInstance().then((prefs) {
      email = prefs.getString('WT_DC_EMAIL');
      password = prefs.getString('WT_DC_PASSWORD');
      if (email != null && password != null) {
        userObj = User(email, password, true);
      }
    });

    return ChangeNotifierProvider<User>(
      create: (context) => userObj,
      child: Consumer<User>(
        builder: (context, currentUser, child) {
          print('currentUser');
          print(currentUser);
          return MaterialApp(
            title: "Login",
            initialRoute: '/',
            routes: {
               '/': (context) => currentUser.isLogged
                ? homeScreen
                : AuthScreen(),
              '/home': (context) => homeScreen,
              '/auth': (context) => AuthScreen()
            },
          );
        },
      ),
    );
  }
}
