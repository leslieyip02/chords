import 'package:chords/audio/sound_font_source.dart';
import 'package:chords/models/bar.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/models/section.dart';
import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/bar/bar_line.dart';
import 'package:just_audio/just_audio.dart';

class SheetPlayer {
  static const String defaultSoundFontPath = 'assets/soundfonts/organ.sf2';
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
    int tempo = 200,
    int beatsPerBar = 4,
    bool loop = false,
    String path = defaultSoundFontPath,
  }) async {
    // TODO: accomodate different time signatures
    double barDuration = beatsPerBar.toDouble() / (tempo.toDouble() / 60.0);

    SoundFontSource source = await SoundFontSource.fromPath(path);
    for (Section section in sheet.sections) {
      int repeatIndex = -1;
      bool repeated = false;
      int index = 0;
      while (index < section.bars.length) {
        if (section.dividers[index] == BarLine.repeatBegin && !repeated) {
          repeatIndex = index;
        }

        Bar bar = section.bars[index];
        // skip to second time
        if (bar.label == '1.' && repeated) {
          do {
            index++;
          } while (section.bars[index].label != '2.');
          bar = section.bars[index];
        }

        double durationPerChord = barDuration / bar.chords.length.toDouble();
        for (Chord chord in bar.chords) {
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
          source.appendNotes(notes, durationPerChord);
        }

        index++;
        if (section.dividers[index] == BarLine.repeatEnd &&
            repeatIndex != -1 &&
            !repeated) {
          index = repeatIndex;
          repeatIndex = -1;
          repeated = true;
        }
      }
    }

    audioPlayer = AudioPlayer();
    await audioPlayer!.setAudioSource(source, preload: false);
    await audioPlayer!.setLoopMode(loop ? LoopMode.all : LoopMode.off);
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
