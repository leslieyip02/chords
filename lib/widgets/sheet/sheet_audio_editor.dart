import 'package:chords/audio/sheet_player.dart';
import 'package:chords/models/sheet.dart';
import 'package:flutter/material.dart';

class SheetAudioEditor extends StatefulWidget {
  static const double minSlider = 60.0;
  static const double maxSlider = 400.0;
  static const int divisions = 341;

  const SheetAudioEditor({
    super.key,
    required this.sheetPlayer,
    required this.sheet,
  });

  final SheetPlayer sheetPlayer;
  final Sheet sheet;

  @override
  State<SheetAudioEditor> createState() => _SheetAudioEditorState();
}

class _SheetAudioEditorState extends State<SheetAudioEditor> {
  int currentSlider = 120;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: 200,
        color: theme.cardColor,
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: add more soundfont options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() => currentSlider++);
                  },
                  icon: Icon(Icons.arrow_left_sharp),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Tempo',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => currentSlider++);
                  },
                  icon: Icon(Icons.arrow_right_sharp),
                ),
              ],
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: currentSlider.toDouble(),
                    min: SheetAudioEditor.minSlider,
                    max: SheetAudioEditor.maxSlider,
                    divisions: SheetAudioEditor.divisions,
                    inactiveColor: theme.colorScheme.outline,
                    label: '   $currentSlider   ',
                    onChanged: (sliderValue) {
                      setState(() => currentSlider = sliderValue.round());
                    },
                    onChangeEnd: (sliderValue) {
                      setState(() => currentSlider = sliderValue.round());
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.check),
                  tooltip: 'Confirm',
                  onPressed: () async {
                    // TODO: make a loading bar
                    widget.sheetPlayer
                        .updateSheet(
                          widget.sheet,
                          // TODO: actually take in tempo
                          tempo: 120,
                          // TODO: check if loop
                        )
                        .then((_) => Navigator.pop(context));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
