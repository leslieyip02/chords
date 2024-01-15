import 'dart:convert';
import 'package:chords/audio/sheet_player.dart';
import 'package:chords/audio/sound_font_source.dart';
import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/shakeable_container.dart';
import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:flutter/material.dart';

class SheetAudioEditor extends StatefulWidget {
  static const int defaultTempo = 120;
  static const String pathPrefix = 'assets/soundfonts/';
  static const String pathSuffix = '.sf2';
  static const String defaultChordSoundFontPath = 'assets/soundfonts/organ.sf2';

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
  final shakeableContainerKey = GlobalKey<ShakeableContainerState>();
  int tempo = SheetAudioEditor.defaultTempo;
  late List<String> paths;
  late SoundFontSettings chordSettings;

  String truncatePath(String path) {
    return path
        .replaceAll(SheetAudioEditor.pathPrefix, '')
        .replaceAll(SheetAudioEditor.pathSuffix, '')
        .split('_')
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  @override
  void initState() {
    super.initState();

    chordSettings = SoundFontSettings(
      SheetAudioEditor.defaultChordSoundFontPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString('AssetManifest.json'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            // placeholder
            return Placeholder();
          }

          Map<String, dynamic> pathMap = jsonDecode(snapshot.data!);
          paths = pathMap.keys
              .where((path) => path.startsWith(SheetAudioEditor.pathPrefix))
              .where((path) => path != SheetPlayer.metronomePath)
              .toList();

          return Container(
            height: 200,
            color: theme.cardColor,
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120.0,
                      child: Text('Audio Preset:'),
                    ),
                    SizedBox(width: 8.0),
                    DropdownButton(
                      value: chordSettings.path,
                      items: paths.map<DropdownMenuItem<String>>((String path) {
                        return DropdownMenuItem<String>(
                          value: path,
                          child: Text(truncatePath(path)),
                        );
                      }).toList(),
                      onChanged: (path) {
                        setState(() => chordSettings.path = path!);
                      },
                    ),
                    SizedBox(width: 8.0),
                    FutureBuilder(
                      future: SoundFontSource.loadSynthesizer(
                        chordSettings.path,
                      ),
                      builder: (BuildContext context,
                          AsyncSnapshot<Synthesizer> snapshot) {
                        if (!snapshot.hasData) {
                          // disabled button placeholder
                          return DropdownButton(
                            disabledHint: Text('Unavailable'),
                            items: null,
                            onChanged: null,
                          );
                        }

                        Synthesizer synthesizer = snapshot.data!;
                        List<Preset> presets = synthesizer.soundFont.presets;
                        return DropdownButton(
                          value: chordSettings.preset,
                          items: presets.indexed.map(
                            ((int, Preset) entry) {
                              final (index, preset) = entry;
                              String name = preset.name
                                  .replaceAll(RegExp(r'[^\w\s]+'), '')
                                  .replaceAll('\n', '');
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text('${index + 1}. $name'),
                              );
                            },
                          ).toList(),
                          onChanged: (preset) {
                            setState(() => chordSettings.preset = preset ?? 0);
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    ShakeableContainer(
                      key: shakeableContainerKey,
                      child: IconButton(
                        icon: Icon(Icons.check),
                        tooltip: 'Confirm',
                        onPressed: () async {
                          try {
                            // TODO: make a loading bar
                            widget.sheetPlayer
                                .updateSheet(
                                  widget.sheet,
                                  chordSettings: chordSettings,
                                  // TODO: actually take in tempo
                                  tempo: 120,
                                )
                                .then((_) => Navigator.pop(context));
                          } on ArgumentError {
                            shakeableContainerKey.currentState?.shake();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
