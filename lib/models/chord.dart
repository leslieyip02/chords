import 'package:chords/models/note.dart';

class Chord {
  Chord(
    this.note,
    this.quality,
    this.originalNotation,
  );

  Note note;
  String quality;
  String originalNotation;
  String? annotation;

  factory Chord.fromString(String notation) {
    RegExp parser = RegExp(r'([A-G][#b]?)(.*)?');
    RegExpMatch? match = parser.firstMatch(notation.trim());
    if (match?.group(1) == null) {
      throw ArgumentError('$notation is not a valid chord');
    }
    Note note = Note.fromString(match?.group(1) as String);
    return Chord(note, match?.group(2) ?? '', notation);
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

  void reset() {
    update(originalNotation);
    annotation = null;
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
