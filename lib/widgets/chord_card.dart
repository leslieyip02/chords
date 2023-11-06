import 'package:flutter/material.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/widgets/sheet_row.dart';
import 'package:google_fonts/google_fonts.dart';

class ChordCard extends StatefulWidget {
  static List<ColorScheme> cardColorSchemes = [
    ColorScheme.fromSeed(seedColor: Colors.red, primary: Colors.red),
    ColorScheme.fromSeed(seedColor: Colors.orange, primary: Colors.orange),
    ColorScheme.fromSeed(seedColor: Colors.amber, primary: Colors.amber),
    ColorScheme.fromSeed(seedColor: Colors.green, primary: Colors.green),
    ColorScheme.fromSeed(seedColor: Colors.blue),
    ColorScheme.fromSeed(seedColor: Colors.indigo, primary: Colors.indigo),
    ColorScheme.fromSeed(seedColor: Colors.purple, primary: Colors.purple),
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
    // final style = theme.textTheme.displayMedium!.copyWith(
    //   color: colorScheme?.onPrimary,
    // );

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
              title: Text('Choose a color:'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (var cardColorScheme in ChordCard.cardColorSchemes)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: MaterialButton(
                        minWidth: 40.0,
                        height: 64.0,
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
