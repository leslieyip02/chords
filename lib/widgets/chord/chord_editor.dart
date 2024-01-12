import 'package:chords/main.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/widgets/chord/chord_card.dart';
import 'package:chords/widgets/shakeable_container.dart';
import 'package:flutter/material.dart';

class ChordEditor extends StatefulWidget {
  static const double margin = 8.0;

  const ChordEditor({
    super.key,
    required this.chord,
    required this.updateColorScheme,
  });

  final Chord chord;
  final Function(ColorScheme) updateColorScheme;

  @override
  State<ChordEditor> createState() => _ChordEditorState();
}

class _ChordEditorState extends State<ChordEditor> {
  final shakeableContainerKey = GlobalKey<ShakeableContainerState>();
  late TextEditingController notationEditor;
  late TextEditingController annotationEditor;

  @override
  void initState() {
    super.initState();

    notationEditor = TextEditingController.fromValue(
      TextEditingValue(text: widget.chord.toString()),
    );
    annotationEditor = TextEditingController.fromValue(
      TextEditingValue(text: widget.chord.annotation ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ChordEditor.margin),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ChordEditor.margin),
              child: Text('Chord:'),
            ),
            Padding(
              padding: EdgeInsets.all(ChordEditor.margin),
              child: ShakeableContainer(
                key: shakeableContainerKey,
                child: TextField(
                  onSubmitted: (input) {
                    try {
                      setState(() => widget.chord.update(input));
                    } on ArgumentError {
                      shakeableContainerKey.currentState?.shake();
                    }
                  },
                  controller: notationEditor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.swap_vert_circle),
                      padding: EdgeInsets.all(ChordCard.margin * 2),
                      tooltip: 'Toggle Enharmonic',
                      onPressed: () {
                        try {
                          notationEditor.value = TextEditingValue(
                            text: Chord.fromString(notationEditor.value.text)
                                .toggleEnharmonic()
                                .toString(),
                          );
                        } on ArgumentError {
                          shakeableContainerKey.currentState?.shake();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ChordCard.margin),
              child: Text('Annotation:'),
            ),
            Padding(
              padding: EdgeInsets.all(ChordCard.margin),
              child: TextField(
                onSubmitted: (input) {
                  setState(() => widget.chord.annotation = input);
                },
                controller: annotationEditor,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            SizedBox(height: ChordCard.margin * 2),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final cardColorSchemeOption
                      in ChordCard.cardColorSchemes)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: ChordCard.margin),
                      child: MaterialButton(
                        minWidth: 36.0,
                        height: 36.0,
                        shape: CircleBorder(),
                        color: cardColorSchemeOption.surface,
                        onPressed: () {
                          setState(() {
                            widget.updateColorScheme(cardColorSchemeOption);
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.chord.reset();
              widget.updateColorScheme(App.colorScheme);
            });
            Navigator.pop(context, 'OK');
          },
          child: Text('Reset'),
        ),
        TextButton(
          onPressed: () {
            try {
              setState(() {
                widget.chord.update(notationEditor.value.text);
                widget.chord.annotation = annotationEditor.value.text;
              });
              Navigator.pop(context, 'OK');
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
