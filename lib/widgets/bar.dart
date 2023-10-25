import 'package:chords/widgets/chord_card.dart';
import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final List<String> chords;

  const Bar({
    super.key,
    required this.chords,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.redAccent, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var chord in chords) Chord(value: chord),
              ],
            )));
  }
}
