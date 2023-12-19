import 'package:chords/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/widgets/shakeable_container.dart';
import 'package:chords/widgets/sheet_row.dart';

class ChordCard extends StatefulWidget {
  static List<ColorScheme> cardColorSchemes = [
    ColorScheme.dark(primary: Color(0xFFF92672), surface: Color(0xFFF92672)),
    ColorScheme.dark(primary: Color(0xFFFD971F), surface: Color(0xFFFD971F)),
    ColorScheme.dark(primary: Color(0xFFF4DF8B), surface: Color(0xFFF4DF8B)),
    ColorScheme.dark(primary: Color(0xFFA6E22E), surface: Color(0xFFA6E22E)),
    ColorScheme.dark(primary: Color(0xFF66D9EF), surface: Color(0xFF66D9EF)),
    ColorScheme.dark(primary: Color(0xFF66A4EF), surface: Color(0xFF66A4EF)),
    ColorScheme.dark(primary: Color(0xFFAE81FF), surface: Color(0xFFAE81FF)),
  ];
  static const double margin = 4.0;

  const ChordCard({
    super.key,
    required this.chord,
  });

  final Chord chord;

  @override
  State<ChordCard> createState() => _ChordCardState();
}

class _ChordCardState extends State<ChordCard> {
  final shakeableContainerKey = GlobalKey<ShakeableContainerState>();
  late ColorScheme cardColorScheme;
  late Color color;
  String annotation = '';

  @override
  void initState() {
    super.initState();
    cardColorScheme = App.colorScheme;
    color = cardColorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = GoogleFonts.barlowCondensed(
      textStyle: theme.textTheme.displayMedium,
      color: cardColorScheme.onSurface,
    );

    String accidental = '';
    if (widget.chord.note.isSharp) {
      accidental = '#';
    } else if (widget.chord.note.isFlat) {
      accidental = 'b';
    }

    final notationEditor = TextEditingController.fromValue(
        TextEditingValue(text: widget.chord.toString()));
    final annotationEditor =
        TextEditingController.fromValue(TextEditingValue(text: annotation));

    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (annotation.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Text(
                annotation,
                style: TextStyle(color: cardColorScheme.primary),
              ),
            ),
          InkWell(
            onTap: () {
              // TODO: add a reset button
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
                        child: Text("Chord:"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ShakeableContainer(
                          key: shakeableContainerKey,
                          child: TextField(
                            onChanged: (input) {
                              // chord is not updated directly
                              // because submit will trigger shake on invalid input
                              setState(() {
                                notationEditor.value =
                                    TextEditingValue(text: input);
                              });
                            },
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
                                padding: EdgeInsets.all(16.0),
                                tooltip: "Toggle Enharmonic",
                                onPressed: () {
                                  try {
                                    Chord toggled = Chord.fromString(
                                            notationEditor.value.text)
                                        .toggleEnharmonic();
                                    notationEditor.value = TextEditingValue(
                                        text: toggled.toString());
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
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Annotation:"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (input) {
                            setState(() => annotationEditor.value =
                                TextEditingValue(text: input));
                          },
                          onSubmitted: (input) {
                            setState(() => annotation = input);
                          },
                          controller: annotationEditor,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var cardColorSchemeOption
                                in ChordCard.cardColorSchemes)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                child: MaterialButton(
                                  minWidth: 36.0,
                                  height: 36.0,
                                  shape: CircleBorder(),
                                  color: cardColorSchemeOption.surface,
                                  onPressed: () {
                                    setState(() {
                                      cardColorScheme = cardColorSchemeOption;
                                      color = cardColorSchemeOption.surface;
                                    });
                                  },
                                ),
                              ),
                          ],
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
                          setState(() {
                            widget.chord.update(notationEditor.value.text);
                            annotation = annotationEditor.value.text;
                          });
                          Navigator.pop(context, 'OK');
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
            onHover: (mouseEnter) {
              setState(() {
                color = mouseEnter
                    ? cardColorScheme.surface.withAlpha(120)
                    : cardColorScheme.surface;
              });
            },
            child: Card(
              // margin: EdgeInsets.zero,
              margin: EdgeInsets.all(ChordCard.margin / 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              color: color,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: SheetRow.getRowHeight(context),
                  ),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        // add constraints to this?
                        Text(
                          widget.chord.note.value.name,
                          style: style,
                        ),
                        SizedBox(width: 2.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              accidental,
                              style: style,
                              textScaleFactor: 0.5,
                            ),
                            // add constraints to this?
                            Text(
                              widget.chord.quality,
                              style: style,
                              textScaleFactor: 0.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
