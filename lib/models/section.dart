import 'package:chords/models/chord.dart';

class Section {
  final String label;
  final List<List<Chord>> bars;

  Section(this.label, this.bars);

  factory Section.fromString(String notation) {
    List<List<Chord>> bars = [];
    for (String line in notation.split('\n')) {
      for (String bar in line.split('|')) {
        bar = bar.trim();
        if (bar.isNotEmpty) {
          bars.add(bar.split(' ').map(Chord.fromString).toList());
        }
      }
    }
    return Section('Section', bars);
  }
}
