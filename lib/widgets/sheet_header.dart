import 'package:flutter/material.dart';
import 'package:chords/models/sheet.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    super.key,
    required this.sheet,
  });

  final Sheet sheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              if (sheet.title != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(sheet.title as String,
                      style: theme.textTheme.displayLarge),
                ),
              if (sheet.composer != null)
                Text(sheet.composer as String,
                    style: theme.textTheme.titleSmall),
            ],
          ),
        );
      },
    );
  }
}
