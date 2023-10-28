import 'package:flutter/material.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/widgets/bar.dart';
import 'package:chords/widgets/bar_line.dart';

class SheetRow extends StatelessWidget {
  static const double rowHeight = 100.0;
  final List<List<Chord>> bars;

  const SheetRow({
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
      height: SheetRow.rowHeight,
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: contents,
      ),
    );
  }
}
