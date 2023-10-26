import 'package:flutter/material.dart';

import 'package:chords/models/chord.dart';
import 'package:chords/widgets/bar.dart';
import 'package:chords/widgets/bar_line.dart';

class ScoreRow extends StatelessWidget {
  final List<List<Chord>> bars;

  const ScoreRow({
    super.key,
    required this.bars,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [BarLine()];
    for (var bar in bars) {
      contents.add(Bar(chords: bar));
      contents.add(BarLine());
    }

    return Container(
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: contents,
        // children: [
        //   for (var bar in bars) Bar(chords: bar),
        // ],
      ),
    );
  }
}
