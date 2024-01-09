import 'package:chords/models/sheet.dart';
import 'package:flutter/material.dart';

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    super.key,
    required this.sheet,
  });

  final Sheet sheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onBackground,
    );
    final subtitleStyle = theme.textTheme.titleSmall!.copyWith(
      color: theme.colorScheme.primary,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            if (sheet.title != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
                child: Text(
                  sheet.title as String,
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            if (sheet.composer != null)
              Text(sheet.composer as String, style: subtitleStyle),
          ],
        );
      },
    );
  }
}
