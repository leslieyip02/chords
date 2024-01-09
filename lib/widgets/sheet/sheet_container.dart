import 'package:chords/models/chord.dart';
import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/chord/chord_editor.dart';
import 'package:chords/widgets/sheet/sheet_header.dart';
import 'package:chords/widgets/sheet/sheet_section.dart';
import 'package:flutter/material.dart';

class SheetContainer extends StatelessWidget {
  const SheetContainer({
    super.key,
    required this.sheet,
  });

  final Sheet sheet;

  static Future<dynamic> showEditingWindow(
    BuildContext context,
    Chord chord,
    Function(ColorScheme) updateColorScheme,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChordEditor(chord: chord, updateColorScheme: updateColorScheme);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sections = [SizedBox(height: 8.0)];
    for (final section in sheet.sections) {
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
