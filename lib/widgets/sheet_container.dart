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
    List<Widget> sections = [SizedBox(height: 8.0)];
    for (var section in sheet.sections) {
      sections.add(SheetSection(section: section));
      sections.add(SizedBox(height: 8.0));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
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
