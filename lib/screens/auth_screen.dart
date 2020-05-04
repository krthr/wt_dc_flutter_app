import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wt_dc_app/models/user_model.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final controllerEmail = new TextEditingController();
  final controllerPass = new TextEditingController();

  Future<User> loadUser() async {
    var userObj = User('', '', false);
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('WT_DC_EMAIL');
    final password = prefs.getString('WT_DC_PASSWORD');
    if (email != null && password != null) {
      userObj = User(email, password, true);
    }
    await new Future.delayed(const Duration(seconds: 5));
    return userObj;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _authentication("", "", true));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: loadUser(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        Widget bodyWidget;
        if (snapshot.hasData) {
          if (snapshot.data.isLogged) {
            bodyWidget = Container(
                child: Column(
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Result: GGG'),
                ),
              ],
            ));
          } else {
            bodyWidget = Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                          controller: controllerEmail,
                          validator: (value) {
                            if (value.isEmpty) return 'Please, enter an email!';
                            return null;
                          }),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controllerPass,
                        validator: (value) {
                          if (value.isEmpty) return 'Please, enter a password!';
                          return null;
                        },
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            String email = controllerEmail.text;
                            String password = controllerPass.text;
                            controllerPass.clear();
                            controllerEmail.clear();
                            _authentication(email, password, false);
                          }
                        },
                        child: Text('Sign up')),
                    FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: Text('Sign in'))
                  ],
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          bodyWidget = Container(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            ),
          );
        } else {
          bodyWidget = Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Auth'),
          ),
          body: Container(
            child: bodyWidget,
          ),
        );
      },
    );
  }

  Future<void> _authentication(String email, String password, bool fromInit) async {
    final prefs = await SharedPreferences.getInstance();
    if (fromInit) {
      final email = prefs.getString('WT_DC_EMAIL');
      final password = prefs.getString('WT_DC_PASSWORD');
      if (email != null && password != null) {
        Provider.of<User>(context, listen: false).logIn(email, password);
        Navigator.pushReplacementNamed(context, "/");
      }
    } else {
      prefs.setString('WT_DC_EMAIL', email);
      prefs.setString('WT_DC_PASSWORD', password);
      Provider.of<User>(context, listen: false).logIn(email, password);
    }
  }
}
