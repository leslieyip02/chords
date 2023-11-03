import 'package:chords/widgets/sheet_header.dart';
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

    List<Widget> sections = sheet.sections
        .map((section) => SheetSection(section: section))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: theme.primaryColorLight,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SheetHeader(sheet: sheet),
                ...sections,
              ],
            ),
          ),
        );
      },
    );
  }
}
