import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  var songPath = '';

  void setSongPath(String path) {
    songPath = path;
  }
}
