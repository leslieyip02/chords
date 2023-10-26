import 'package:chords/widgets/sheet_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:chords/models/sheet.dart';
import 'package:chords/providers/app_state.dart';

class ChordsPage extends StatelessWidget {
  static const int barsPerRow = 4;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var song = appState.song;

    return FutureBuilder<String>(
        future: rootBundle.loadString('assets/sheets/$song'),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return Text('woops');
          }
          Sheet sheet = Sheet.fromString(snapshot.data as String);

          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              height: double.infinity,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              // debug purposes
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent, width: 5),
              ),
              child: SingleChildScrollView(
                  child: Column(
                children: sheet.sections
                    .map((section) => ScoreSection(section: section))
                    .toList(),
              )),
            );
          });
        });
  }
}
