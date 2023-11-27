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

    final theme = Theme.of(context);

    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bar.label != null)
            Container(
              margin: EdgeInsets.symmetric(vertical: ChordCard.margin),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: theme.colorScheme.outline))),
              child: Text(
                bar.label as String,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: contents,
          ),
        ],
      ),
    );
  }
}
