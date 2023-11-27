import 'package:chords/models/chord.dart';

class Bar {
  static const String firstTime = '1.';
  static const String secondTime = '2.';

  final List<Chord> chords;

  Bar(this.chords);

  factory Bar.fromString(String notation) {
    List<Chord> chords = notation
        .split(RegExp(r'[\s+]'))
        .map((splitNotation) => splitNotation.trim())
        .map(Chord.fromString)
        .toList();
    return Bar(chords);
  }

  Bar transpose(int steps) {
    for (var chord in chords) {
      chord.transpose(steps);
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
