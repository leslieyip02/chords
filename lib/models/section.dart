import 'package:chords/models/chord.dart';

class Section {
  static const String labelLabel = 'section:';

  final String? label;
  final List<List<Chord>> bars;

  Section(this.label, this.bars);

  factory Section.fromString(String notation) {
    String? label;
    List<List<Chord>> bars = [];
    List<String> lines = notation.trim().split('\n');
    if (lines.isEmpty) {
      throw ArgumentError('$notation is not a valid section');
    }

    if (lines[0].startsWith(Section.labelLabel)) {
      label = lines[0].substring(Section.labelLabel.length).trim();
      lines.removeAt(0);
    }

    for (String line in lines) {
      for (String bar in line.split('|')) {
        bar = bar.trim();
        if (bar.isNotEmpty) {
          bars.add(bar.split(' ').map(Chord.fromString).toList());
        }
      }
    }
    return Section(label, bars);
  }

  Section transpose(int steps) {
    for (var bar in bars) {
      for (var chord in bar) {
        chord.transpose(steps);
      }
    }
    return this;
  }
}
