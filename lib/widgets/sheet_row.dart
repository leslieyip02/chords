import 'package:chords/models/bar.dart';
import 'package:chords/widgets/chord_card.dart';
import 'package:flutter/material.dart';
import 'package:chords/widgets/bar_container.dart';
import 'package:chords/widgets/bar_line.dart';

class SheetRow extends StatelessWidget {
  static const double rowHeight = 80.0;

  const SheetRow({
    super.key,
    required this.bars,
    required this.dividers,
  });

  final List<Bar> bars;
  final List<String> dividers;

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [BarLine.of(dividers.first)];
    for (int i = 0; i < bars.length; i++) {
      contents.add(BarContainer(bar: bars[i]));
      contents.add(BarLine.of(dividers[i + 1]));
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: ChordCard.margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: contents,
      ),
    );
  }
}
