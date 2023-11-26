import 'package:chords/widgets/chord_card.dart';
import 'package:flutter/material.dart';
import 'package:chords/models/bar.dart';

class BarContainer extends StatelessWidget {
  const BarContainer({
    super.key,
    required this.bar,
  });

  final Bar bar;

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [ChordCard(chord: bar.chords[0])];
    for (int i = 1; i < bar.chords.length; i++) {
      contents.add(SizedBox(width: ChordCard.margin));
      contents.add(ChordCard(chord: bar.chords[i]));
    }

    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // WIP for annotations
          // Container(
          //   decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          //   height: 20,
          //   child: Text("Placeholder"),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: contents,
          ),
        ],
      ),
    );
  }
}
