import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chords/main.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/widgets/shakeable_container.dart';
import 'package:chords/widgets/sheet_row.dart';

class ChordCard extends StatefulWidget {
  static List<ColorScheme> cardColorSchemes = [
    ColorScheme.fromSeed(seedColor: Colors.red, primary: Color(0xFFF92672)),
    ColorScheme.fromSeed(seedColor: Colors.orange, primary: Color(0xFFFD971F)),
    ColorScheme.fromSeed(seedColor: Colors.yellow, primary: Color(0xFFF4DF8B)),
    ColorScheme.fromSeed(seedColor: Colors.green, primary: Color(0xFFA6E22E)),
    ColorScheme.fromSeed(seedColor: Colors.blue, primary: Color(0xFF66D9EF)),
    App.colorScheme,
    ColorScheme.fromSeed(seedColor: Colors.indigo, primary: Color(0xFFAE81FF)),
  ];

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
  ColorScheme? colorScheme;
  Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (colorScheme == null) {
      setState(() {
        colorScheme = theme.colorScheme;
        color = theme.colorScheme.primary;
      });
    }
    final style = GoogleFonts.barlowCondensed(
      textStyle: theme.textTheme.displayMedium,
      color: colorScheme?.onPrimary,
    );

    String accidental = '';
    if (widget.chord.note.isSharp) {
      accidental = '#';
    } else if (widget.chord.note.isFlat) {
      accidental = 'b';
    }

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              surfaceTintColor: theme.canvasColor,
              title: Text(
                'Edit:',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShakeableContainer(
                    key: shakeableContainerKey,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: TextField(
                        style: style.copyWith(
                          color: colorScheme?.primary,
                        ),
                        textAlign: TextAlign.center,
                        onSubmitted: (notation) {
                          try {
                            widget.chord.update(notation);
                            setState(() {});
                          } on ArgumentError {
                            shakeableContainerKey.currentState?.shake();
                          }
                        },
                        controller: TextEditingController.fromValue(
                          TextEditingValue(text: widget.chord.toString()),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var cardColorScheme in ChordCard.cardColorSchemes)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: MaterialButton(
                            minWidth: 40.0,
                            height: 48.0,
                            onPressed: () {
                              setState(() {
                                colorScheme = cardColorScheme;
                                color = cardColorScheme.primary;
                              });
                            },
                            color: cardColorScheme.primary,
                            shape: CircleBorder(),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
        onHover: (mouseEnter) {
          setState(() {
            color = mouseEnter
                ? colorScheme?.secondary
                : color = colorScheme?.primary;
          });
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          color: color,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: SheetRow.rowHeight,
              ),
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
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
    );
  }
}
