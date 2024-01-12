import 'package:chords/models/sheet.dart';
import 'package:chords/screens/sheet_page.dart';
import 'package:chords/widgets/shakeable_container.dart';
import 'package:flutter/material.dart';

class SheetEditor extends StatefulWidget {
  static const double margin = 8.0;
  static final String hintText = [
    'info:',
    'title:',
    'composer:',
    '-----',
    'section: A',
    '|| your | chords | here ||'
  ].join('\n');

  const SheetEditor({
    super.key,
  });

  @override
  State<SheetEditor> createState() => _SheetEditorState();
}

class _SheetEditorState extends State<SheetEditor> {
  final shakeableContainerKey = GlobalKey<ShakeableContainerState>();
  final customSheetEditor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SheetEditor.margin),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SheetEditor.margin),
            child: Text('Custom Sheet:'),
          ),
          Padding(
            padding: EdgeInsets.all(SheetEditor.margin),
            child: ShakeableContainer(
              key: shakeableContainerKey,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: customSheetEditor,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: SheetEditor.hintText,
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            try {
              Sheet sheet = Sheet.fromString(customSheetEditor.text);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SheetPage(sheet: sheet)),
              );
            } on ArgumentError {
              shakeableContainerKey.currentState?.shake();
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
