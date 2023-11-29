import 'package:chords/models/note.dart';

class Chord {
  Note note;
  String quality;

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

  Chord transpose(int steps) {
    note = note.transpose(steps);
    return this;
  }

  Chord toggleEnharmonic() {
    note = note.toggleEnharmonic();
    return this;
  }

  void update(String notation) {
    RegExp parser = RegExp(r'^([A-G][#b]?)(.*)?');
    RegExpMatch? match = parser.firstMatch(notation.trim());
    if (match?.group(1) == null) {
      throw ArgumentError('$notation is not a valid chord');
    }
    note = Note.fromString(match?.group(1) as String);
    quality = match?.group(2) ?? '';
  }

  @override
  String toString() {
    return note.toString() + quality;
  }

  @override
  int get hashCode => Object.hash(note, quality);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
