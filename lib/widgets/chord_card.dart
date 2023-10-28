import 'package:flutter/material.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/widgets/sheet_row.dart';

class ChordCard extends StatelessWidget {
  final Chord chord;

  const ChordCard({
    super.key,
    required this.chord,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    String accidental = '';
    if (chord.note.isSharp) {
      accidental = '#';
    } else if (chord.note.isFlat) {
      accidental = 'b';
    }

    return Expanded(
      flex: 1,
      child: Card(
        color: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: SheetRow.rowHeight,
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Text(
                    chord.note.value.name,
                    style: style,
                  ),
                  SizedBox(width: 2.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accidental,
                        style: style,
                        textScaleFactor: 0.8,
                      ),
                      Text(
                        chord.quality,
                        style: style,
                        textScaleFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
