import 'package:chords/main.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/widgets/sheet/sheet_container.dart';
import 'package:chords/widgets/sheet/sheet_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChordCard extends StatefulWidget {
  static List<ColorScheme> cardColorSchemes = [
    ColorScheme.dark(primary: Color(0xFFF92672), surface: Color(0xFFF92672)),
    ColorScheme.dark(primary: Color(0xFFFD971F), surface: Color(0xFFFD971F)),
    ColorScheme.dark(primary: Color(0xFFF4DF8B), surface: Color(0xFFF4DF8B)),
    ColorScheme.dark(primary: Color(0xFFA6E22E), surface: Color(0xFFA6E22E)),
    ColorScheme.dark(primary: Color(0xFF66D9EF), surface: Color(0xFF66D9EF)),
    ColorScheme.dark(primary: Color(0xFF66A4EF), surface: Color(0xFF66A4EF)),
    ColorScheme.dark(primary: Color(0xFFAE81FF), surface: Color(0xFFAE81FF)),
    App.colorScheme,
  ];
  static const double margin = 4.0;

  const ChordCard({
    super.key,
    required this.chord,
    this.flex = 1,
  });

  final Chord chord;
  final int flex;

  @override
  State<ChordCard> createState() => _ChordCardState();
}

class _ChordCardState extends State<ChordCard> {
  late ColorScheme cardColorScheme;
  late Color color;

  void updateColorScheme(ColorScheme colorScheme) {
    setState(() {
      cardColorScheme = colorScheme;
      color = cardColorScheme.surface;
    });
  }

  @override
  void initState() {
    super.initState();
    updateColorScheme(App.colorScheme);
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

    return Expanded(
      flex: widget.flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.chord.annotation?.isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Text(
                widget.chord.annotation!,
                style: TextStyle(color: cardColorScheme.primary),
              ),
            ),
          InkWell(
            onTap: () {
              SheetContainer.showEditingWindow(
                context,
                widget.chord,
                updateColorScheme,
              ).then((_) => setState(() {}));
            },
            onHover: (mouseEnter) {
              setState(() {
                color = mouseEnter
                    ? cardColorScheme.surface.withAlpha(120)
                    : cardColorScheme.surface;
              });
            },
            child: Card(
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
                        Text(widget.chord.note.value.name, style: style),
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
        ],
      ),
    );
  }
}
