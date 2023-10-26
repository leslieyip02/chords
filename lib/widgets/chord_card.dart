import 'package:flutter/material.dart';

import 'package:chords/models/chord.dart';

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

    return Expanded(
        flex: 1,
        // width: 100,
        child: Card(
          color: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              chord.note.toString(),
              style: style,
              textScaleFactor: 0.5,
            ),
          ),
        ));
  }
}
