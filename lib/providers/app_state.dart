import 'package:flutter/material.dart';
import 'package:chords/widgets/sheet_selector.dart';

class AppState extends ChangeNotifier {
  var sheetPath = SheetSelector.pathDoesNotExist;

  void setSongPath(String path) {
    sheetPath = path;
  }
}
