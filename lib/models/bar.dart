import 'package:chords/models/chord.dart';

class Bar {
  final List<Chord> chords;
  String? label;

  Bar(this.chords, {this.label});

  factory Bar.fromString(String notation) {
    // find text nested in brackets
    RegExp bracket = RegExp(r'\{(.+?)\}');
    RegExpMatch? match = bracket.firstMatch(notation.trim());
    String? label = match?.group(1);
    List<Chord> chords = notation
        .replaceAll(bracket, '')
        .split(RegExp(r'[\s+]'))
        .map((splitNotation) => splitNotation.trim())
        .where((trimmed) => trimmed.isNotEmpty)
        .map(Chord.fromString)
        .toList();
    return Bar(chords, label: label);
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
