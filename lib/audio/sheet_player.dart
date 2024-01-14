import 'package:chords/audio/sound_font_source.dart';
import 'package:chords/models/bar.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/models/section.dart';
import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/bar/bar_line.dart';
import 'package:just_audio/just_audio.dart';

class SheetPlayer {
  static const String defaultChordSoundFontPath = 'assets/soundfonts/organ.sf2';
  static const String defaultDrumsSoundFontPath = 'assets/soundfonts/drums.sf2';
  static const Map<String, int> noteToSoundFontKey = {
    'C': 60,
    'Db': 61,
    'D': 62,
    'Eb': 63,
    'E': 64,
    'F': 65,
    'Gb': 66,
    'G': 67,
    'Ab': 68,
    'A': 69,
    'Bb': 70,
    'B': 71,
  };

  SheetPlayer();

  AudioPlayer? audioPlayer;
  bool ready = false;

  Future<SheetPlayer> updateSheet(
    Sheet sheet, {
    int tempo = 120,
    int beatsPerBar = 4,
    String chordSoundFontPath = SheetPlayer.defaultChordSoundFontPath,
    String drumsSoundFontPath = SheetPlayer.defaultDrumsSoundFontPath,
  }) async {
    // TODO: accomodate different time signatures
    double barDuration = beatsPerBar.toDouble() / (tempo.toDouble() / 60.0);

    SoundFontSource source = await SoundFontSource.fromPaths(
      chordSoundFontPath,
      drumsSoundFontPath,
    );
    for (Section section in sheet.sections) {
      int repeatIndex = -1;
      bool repeated = false;
      int barIndex = 0;
      while (barIndex < section.bars.length) {
        if (section.dividers[barIndex] == BarLine.repeatBegin && !repeated) {
          repeatIndex = barIndex;
        }

        Bar bar = section.bars[barIndex];
        // skip to second time
        if (bar.label == '1.' && repeated) {
          do {
            barIndex++;
          } while (section.bars[barIndex].label != '2.');
          bar = section.bars[barIndex];
        }

        // this doesn't handle offbeats
        int chordIndex = 0;
        int beatsPerChord = beatsPerBar ~/ bar.chords.length;
        double durationPerBeat = barDuration / beatsPerBar;
        while (chordIndex < bar.chords.length) {
          Chord chord = bar.chords[chordIndex];
          int beats = beatsPerChord;
          while (chordIndex + 1 < bar.chords.length &&
              chord == bar.chords[chordIndex + 1]) {
            chordIndex++;
            beats++;
          }
          double duration = beats * durationPerBeat;

          int highest = -1;
          Iterable<SoundFontNote> notes = chord.arpeggiate().map((note) {
            String noteString = note.toString();
            return SheetPlayer.noteToSoundFontKey.containsKey(noteString)
                ? SheetPlayer.noteToSoundFontKey[noteString]
                : SheetPlayer
                    .noteToSoundFontKey[note.toggleEnharmonic().toString()];
          }).map((key) {
            if (key! < highest) {
              key += 12;
            }
            if (key > highest) {
              highest = key;
            }
            return SoundFontNote(key, 120);
          });
          source.appendNotes(notes, duration, beats: beats);

          chordIndex++;
        }

        barIndex++;
        if (section.dividers[barIndex] == BarLine.repeatEnd &&
            repeatIndex != -1 &&
            !repeated) {
          barIndex = repeatIndex;
          repeatIndex = -1;
          repeated = true;
        }
      }
    }

    audioPlayer = AudioPlayer();
    await audioPlayer!.setAudioSource(source, preload: false);
    await audioPlayer!.setLoopMode(LoopMode.all);
    ready = true;
    return this;
  }

  Future<void> play() async {
    if (audioPlayer == null) {
      return;
    }
    await audioPlayer!.pause();
    await audioPlayer!.play();
  }

  Future<void> pause() async {
    if (audioPlayer == null) {
      return;
    }
    await audioPlayer!.pause();
  }

  // Future<void> reset() async {
  //   await audioPlayer.pause();
  //   await audioPlayer.seek(Duration.zero);
  // }
}
