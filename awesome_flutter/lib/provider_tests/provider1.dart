import 'package:flutter/material.dart';

class Model1 with ChangeNotifier{
  String _uid;
  String _sid;

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
    notifyListeners();
  }

  String get sid => _sid;

  set sid(String value) {
    _sid = value;
    notifyListeners();
  }

}