import 'package:flutter/material.dart';
import 'package:chords/widgets/sheet_selector.dart';
import 'package:chords/widgets/shakeable_container.dart';
import 'package:chords/screens/sheet_page.dart';
import 'package:chords/models/sheet.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final shakeableContainerKey = GlobalKey<ShakeableContainerState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final customSheetEditor = TextEditingController();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Center(
            child: SheetSelector(),
          ),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.background,
            leading: Icon(Icons.music_note_outlined),
            actions: [
              IconButton(
                icon: Icon(Icons.dashboard_customize),
                tooltip: "Custom",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Custom Sheet:"),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ShakeableContainer(
                              key: shakeableContainerKey,
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: customSheetEditor,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: [
                                    'info:',
                                    'title:',
                                    'composer:',
                                    '-----',
                                    'section: A',
                                    '|| your | chords | here ||'
                                  ].join('\n'),
                                  hintStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.normal),
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
                              Sheet sheet =
                                  Sheet.fromString(customSheetEditor.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SheetPage(sheet: sheet)));
                            } on ArgumentError {
                              shakeableContainerKey.currentState?.shake();
                            }
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(width: 16.0),
            ],
          ),
        );
      },
    );
  }
}
