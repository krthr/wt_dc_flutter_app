import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wt_dc_app/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Email: ${Provider.of<User>(context, listen: false).email}'),
          FlatButton(
              onPressed: () {
                _logout();
              },
              child: Text('Logout'))
        ],
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Provider.of<User>(context, listen: false).changeLoggedStatus(false);
    Navigator.pushReplacementNamed(context, "/");
  }
}