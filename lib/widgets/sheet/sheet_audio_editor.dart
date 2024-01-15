import 'dart:convert';
import 'package:chords/audio/sheet_player.dart';
import 'package:chords/audio/sound_font_source.dart';
import 'package:chords/models/sheet.dart';
import 'package:chords/screens/sheet_page.dart';
import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SheetAudioEditor extends StatefulWidget {
  static const int defaultTempo = 120;
  static const String pathPrefix = 'assets/soundfonts/';
  static const String pathSuffix = '.sf2';
  static const String defaultChordSoundFontPath = 'assets/soundfonts/organ.sf2';
  static const double minSlider = 60.0;
  static const double maxSlider = 400.0;
  static final int divisions = (minSlider.abs() + maxSlider).toInt();

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

class _SheetAudioEditorState extends State<SheetAudioEditor>
    with TickerProviderStateMixin {
  int currentSlider = SheetAudioEditor.defaultTempo;
  late List<String> paths;
  late SoundFontSettings chordSettings;
  late AnimationController loadingAnimationController;

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

    loadingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    loadingAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
          height: 240.0,
          color: theme.cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: loadingAnimationController.value,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() => currentSlider--);
                          },
                          icon: Icon(Icons.arrow_left_sharp),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Tempo: $currentSlider',
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
                    SizedBox(height: 8.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton(
                            value: chordSettings.path,
                            items: paths.map<DropdownMenuItem<String>>(
                              (String path) {
                                return DropdownMenuItem<String>(
                                  value: path,
                                  child: Text(truncatePath(path)),
                                );
                              },
                            ).toList(),
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
                              List<Preset> presets =
                                  synthesizer.soundFont.presets;
                              return DropdownButton(
                                value: chordSettings.preset,
                                items: presets.indexed.map(
                                  ((int, Preset) entry) {
                                    final (index, preset) = entry;
                                    RegExp unicode = RegExp(r'[^\w\s]+');
                                    String label = preset.name
                                        .replaceAll(unicode, '')
                                        .replaceAll('\n', '')
                                        .trim();
                                    return DropdownMenuItem<int>(
                                      value: index,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              width <= SheetPage.narrowThreshold
                                                  ? 80.0
                                                  : double.infinity,
                                        ),
                                        child: Text(
                                          label,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (preset) {
                                  setState(
                                    () => chordSettings.preset = preset ?? 0,
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            icon: Icon(Icons.check_circle),
                            color: theme.colorScheme.primary,
                            tooltip: 'Confirm',
                            onPressed: () async {
                              loadingAnimationController.repeat();

                              // compute doesn't work for web
                              await compute(
                                (data) async {
                                  return await widget.sheetPlayer
                                      .updateSheet(data);
                                },
                                SheetUpdateData(
                                  widget.sheet,
                                  chordSettings,
                                  tempo: currentSlider,
                                ),
                              ).then((_) => Navigator.pop(context));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
