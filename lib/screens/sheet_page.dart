import 'package:chords/widgets/sheet_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chords/providers/app_state.dart';

class ChordsPage extends StatelessWidget {
  static const int barsPerRow = 4;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var sections = appState.sections;

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        // debug purposes
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.redAccent, width: 5),
        // ),
        child: SingleChildScrollView(
            child: Column(
          children: sections.entries
              .map((entry) => SizedBox(
                    child: ScoreSection(label: entry.key, bars: entry.value),
                  ))
              .toList(),
        )),
        // child: Column(
        //   children: sections.entries
        //       .map((entry) => SizedBox(
        //             child: ScoreSection(label: entry.key, bars: entry.value),
        //           ))
        //       .toList(),
        // ),
      );
    });
  }
}
