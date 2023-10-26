import 'package:chords/models/note.dart';

// enum ChordQuality { major, dominant, minor, halfDiminished, diminished, other };

class Chord {
  final Note note;
  final String quality;
  // final ChordQuality quality;

  Chord(this.note, this.quality);

  factory Chord.fromString(String notation) {
    RegExp parser = RegExp(r'([A-G][#b]?)(.*)?');
    RegExpMatch? match = parser.firstMatch(notation.trim());
    if (match?.group(1) == null) {
      throw ArgumentError('$notation is not a valid chord');
    }
    Note note = Note.fromString(match?.group(1) as String);
    return Chord(note, match?.group(2) ?? '');
  }
}
