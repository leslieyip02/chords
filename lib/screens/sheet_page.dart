import 'dart:io';
import 'package:chords/audio/sheet_player.dart';
import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/sheet/sheet_audio_editor.dart';
import 'package:chords/widgets/sheet/sheet_container.dart';
import 'package:chords/widgets/sheet/sheet_transposer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SheetPage extends StatefulWidget {
  static const int maxBarsPerRowNarrow = 2;
  static const int maxBarsPerRowWide = 4;
  static const double narrowThreshold = 600;

  const SheetPage({
    super.key,
    this.sheet,
    this.songPath,
  });

  final Sheet? sheet;
  final String? songPath;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  Sheet? sheet;
  int currentTranspose = 0;
  bool audioSupported = kIsWeb || Platform.isAndroid || Platform.isIOS;
  bool playingAudio = false;
  SheetPlayer sheetPlayer = SheetPlayer();

  void transposeSheet(int steps) {
    setState(() {
      sheet!.transpose(steps);
      currentTranspose += SheetTransposer.divisions ~/ 2 + steps;
      currentTranspose %= SheetTransposer.divisions;
      currentTranspose -= SheetTransposer.divisions ~/ 2;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.sheet != null) {
      setState(() => sheet = widget.sheet!);
    } else if (widget.songPath != null) {
      rootBundle.loadString(widget.songPath!).then((sheetValue) {
        setState(() => sheet = Sheet.fromString(sheetValue));
      });
    } else {
      throw ArgumentError('SheetPage requires either a sheet or a songPath');
    }
  }

  @override
  void dispose() {
    sheetPlayer.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (sheet == null) {
      // placeholder while waiting for sheet to load
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SheetContainer(sheet: sheet!),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.background,
            leading: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  tooltip: 'Back',
                  onPressed: () => Navigator.pop(context),
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.restart_alt),
                tooltip: 'Reset',
                onPressed: () => setState(() {
                  // hack to reload the current sheet to resets
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SheetPage(sheet: sheet?.reset()),
                    ),
                  );
                }),
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.edit_note),
                tooltip: 'Annotate',
                onPressed: () => setState(() => sheet!.autoAnnotate()),
              ),
              SizedBox(width: 8.0),
              sheetPlayer.ready && audioSupported
                  ? playingAudio
                      ? IconButton(
                          icon: Icon(Icons.pause),
                          tooltip: 'Pause',
                          onPressed: () {
                            setState(() => playingAudio = false);
                            sheetPlayer.pause();
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.play_arrow),
                          tooltip: 'Play',
                          onPressed: () {
                            setState(() => playingAudio = true);
                            sheetPlayer.play();
                          },
                        )
                  : IconButton(
                      icon: Icon(Icons.play_disabled),
                      tooltip: 'Audio not configured',
                      onPressed: null,
                    ),
              SizedBox(width: 8.0),
              audioSupported
                  ? IconButton(
                      icon: Icon(Icons.audio_file),
                      tooltip: 'Configure audio',
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SheetAudioEditor(
                              sheetPlayer: sheetPlayer,
                              sheet: sheet!,
                            );
                          },
                        ).then((_) => setState(() {}));
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.audio_file),
                      tooltip: 'Audio is unavailable',
                      onPressed: null,
                    ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.swap_vert),
                tooltip: 'Transpose',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SheetTransposer(
                        currentTranspose: currentTranspose,
                        transposeSheet: transposeSheet,
                      );
                    },
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
