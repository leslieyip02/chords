import 'package:chords/widgets/chord_card.dart';
import 'package:flutter/material.dart';
import 'package:chords/models/chord.dart';

class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.chords,
  });

  final List<Chord> chords;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (var chord in chords) ChordCard(chord: chord),
        ],
      ),
    );
  }
}
