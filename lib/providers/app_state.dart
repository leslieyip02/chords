import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  var sheetPath = '';

  void setSheetPath(String path) {
    sheetPath = path;
  }
}
