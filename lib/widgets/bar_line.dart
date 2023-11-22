import 'package:chords/main.dart';
import 'package:chords/widgets/chord_card.dart';
import 'package:flutter/material.dart';

class BarLine extends StatelessWidget {
  const BarLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Container(
        width: 2.0,
        height: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: ChordCard.margin),
        color: App.colorScheme.outline,
      ),
    );
  }
}
