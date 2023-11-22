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
  static const double margin = 6.0;

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
        color = theme.colorScheme.surface;
      });
    }
    final style = GoogleFonts.barlowCondensed(
      textStyle: theme.textTheme.displayMedium,
      color: colorScheme?.onSurface,
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
              surfaceTintColor: theme.colorScheme.surface,
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
                        style: style,
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
                                color = cardColorScheme.surface;
                              });
                            },
                            color: cardColorScheme.surface,
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
                ? colorScheme?.surface.withAlpha(120)
                : colorScheme?.surface;
          });
        },
        child: Card(
          // margin: EdgeInsets.symmetric(horizontal: 1.0),
          margin: EdgeInsets.zero,
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
