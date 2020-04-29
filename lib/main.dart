import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wt_dc_app/models/user_model.dart';
import 'package:wt_dc_app/screens/home_scree.dart';
import 'package:wt_dc_app/screens/sign_in_screen.dart';
import 'package:wt_dc_app/screens/sign_up_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Scaffold signup = new Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: SignUpScreen(),
    );
    Scaffold home = Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: HomeScreen(),
    );
    Scaffold signIn = new Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: SignInScreen(),
    );
    return ChangeNotifierProvider<User>(
        create: (context) => User(),
        child: Consumer<User>(builder: (context, currentUser, child) {
          return MaterialApp(title: "Login", initialRoute: '/', routes: {
            '/': (context) => Provider.of<User>(context, listen: false).isLogged
                ? home
                : signup,
            '/home': (context) => home,
            '/signin': (context) => signIn
          });
        }));
  }
}
