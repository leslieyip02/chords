import 'package:chords/widgets/sheet_section.dart';
import 'package:flutter/material.dart';
import 'package:chords/models/sheet.dart';

class SheetContainer extends StatelessWidget {
  const SheetContainer({
    super.key,
    required this.sheet,
  });

  final Sheet sheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge;

    List<Widget> sections = sheet.sections
        .map((section) => SheetSection(section: section))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: theme.primaryColorLight,
          height: double.infinity,
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(sheet.title, style: style),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(sheet.composer)],
                ),
                ...sections,
              ],
            ),
          ),
        );
      },
    );
  }
}
