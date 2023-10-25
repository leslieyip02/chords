import 'dart:math';
import 'package:chords/widgets/score_row.dart';
import 'package:flutter/material.dart';

import 'package:chords/screens/score_page.dart';

class ScoreSection extends StatelessWidget {
  final String label;
  final List<List<String>> bars;

  const ScoreSection({
    super.key,
    required this.label,
    required this.bars,
  });

  @override
  Widget build(BuildContext context) {
    List<List<List<String>>> rows = [];
    for (int i = 0; i < bars.length; i += ChordsPage.barsPerRow) {
      int start = i;
      int end = min(i + ChordsPage.barsPerRow, bars.length);
      rows.add(bars.sublist(start, end));
    }

    return Container(
        margin: EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Text(
                label,
                textScaleFactor: 2.0,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            for (var row in rows) ScoreRow(bars: row),
          ],
        ));
  }
}
