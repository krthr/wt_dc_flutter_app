import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String _email;
  String _password;
  bool _isLogged;
  
  User(this._email,this._password, this._isLogged);

  void logIn(String email, String password) {
    this._email = email;
    this._password = password;
    this._isLogged = true;
    print('USER LOGIN FROM CONTROLLER');
    notifyListeners();
  }

  void changeLoggedStatus(bool isLogged) {
    this._isLogged = isLogged;
    notifyListeners();
  }

  bool userExists(String email, String password) {
    return this._email == email && this._password == password;
  }

  bool get isLogged => _isLogged;
  
  String get email => _email;
  
  String get password => _password;
}