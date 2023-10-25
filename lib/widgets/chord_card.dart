import 'package:flutter/material.dart';

class Chord extends StatelessWidget {
  final String value;

  const Chord({
    super.key,
    required this.value,
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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              value,
              style: style,
              textScaleFactor: 0.5,
            ),
          ),
        ));
  }
}
