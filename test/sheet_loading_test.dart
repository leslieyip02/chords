import 'dart:convert';
import 'package:chords/models/sheet.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Load all sheets', () {
    rootBundle.loadString('AssetManifest.json').then((data) {
      Map<String, dynamic> pathMap = jsonDecode(data);
      List<String> paths = pathMap.keys
          .where((path) => path.startsWith('assets/sheets/'))
          .toList();
      for (final path in paths) {
        rootBundle.loadString(path).then((sheetValue) {
          Sheet path = Sheet.fromString(sheetValue);
          assert(path.title != null);
          assert(path.composer != null);
          assert(path.sections.isNotEmpty);
        });
      }
    });
  });
}
