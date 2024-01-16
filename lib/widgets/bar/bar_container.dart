import 'package:chords/models/bar.dart';
import 'package:chords/widgets/chord/chord_card.dart';
import 'package:flutter/material.dart';

class BarContainer extends StatelessWidget {
  const BarContainer({
    super.key,
    required this.bar,
  });

  final Bar bar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> contents = [];
    int index = 0;
    while (index < bar.chords.length) {
      int flex = 1;
      while (index + flex < bar.chords.length &&
          bar.chords[index] == bar.chords[index + flex]) {
        flex++;
      }
      contents.add(ChordCard(chord: bar.chords[index], flex: flex));
      index += flex;
      if (index < bar.chords.length) {
        contents.add(SizedBox(width: ChordCard.margin));
      }
    }

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
                  bottom: BorderSide(color: theme.colorScheme.outline),
                ),
              ),
              child: Text(bar.label!),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: contents,
          ),
        ],
      ),
    );
  }
}
