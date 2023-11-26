import 'package:chords/models/chord.dart';

class Bar {
  static const String singleBarLine = '|';
  static const String doubleBarLine = '||';
  static const String repeatBegin = '[:';
  static const String repeatEnd = ':]';
  static const String firstTime = '1.';
  static const String secondTime = '2.';

  final List<Chord> chords;

  Bar(this.chords);

  factory Bar.fromString(String notation) {
    // RegExp dividerParser = RegExp(r'(\|+)|(\[:)|(:\])');
    // List<String> dividers =
    //     notation.allMatches(notation).map((match) => match.toString()).toList();
    // List<Chord> chords =
    //     notation.split(dividerParser).map(Chord.fromString).toList();
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
