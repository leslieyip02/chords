import 'package:chords/models/chord.dart';

class Bar {
  const Bar(
    this.chords,
    this.beatsPerBar, {
    this.label,
  });

  final List<Chord> chords;
  final int beatsPerBar;
  final String? label;

  factory Bar.fromString(String notation, {int beatsPerBar = 4}) {
    // find label nested in brackets
    RegExp bracket = RegExp(r'\{(.+?)\}');
    RegExpMatch? match = bracket.firstMatch(notation.trim());
    String? label = match?.group(1);

    List<Chord> chords = [];
    Iterable<String> chunks = notation
        .replaceAll(bracket, '')
        .split(RegExp(r'[\s+]'))
        .map((splitNotation) => splitNotation.trim())
        .where((trimmed) => trimmed.isNotEmpty);
    if (beatsPerBar % chunks.length != 0) {
      throw ArgumentError('Unexpected number of chords');
    }
    // use . as a placeholder to extend previous chord
    // for funny time signatures
    for (String chunk in chunks) {
      Chord chord =
          chunk == '.' ? chords.lastOrNull!.copy() : Chord.fromString(chunk);
      chords.add(chord);
    }
    return Bar(chords, beatsPerBar, label: label);
  }

  Bar transpose(int steps) {
    for (final chord in chords) {
      chord.transpose(steps);
    }
    return this;
  }

  Bar autoAnnotate() {
    for (final chord in chords) {
      chord.autoAnnoate();
    }
    return this;
  }

  @override
  int get hashCode => chords.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Bar) {
      return false;
    }
    Bar otherBar = other;
    if (chords.length != otherBar.chords.length) {
      return false;
    }
    for (int i = 0; i < chords.length; i++) {
      if (chords[i] != otherBar.chords[i]) {
        return false;
      }
    }
    return true;
  }
}
