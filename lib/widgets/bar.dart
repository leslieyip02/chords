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
    List<Widget> contents = [ChordCard(chord: chords[0])];
    for (int i = 1; i < chords.length; i++) {
      contents.add(SizedBox(width: ChordCard.margin));
      contents.add(ChordCard(chord: chords[i]));
    }

    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: contents,
      ),
    );
  }
}
