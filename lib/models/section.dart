import 'package:chords/models/bar.dart';

class Section {
  static const String labelLabel = 'section:';

  final String? label;
  final List<Bar> bars;
  final List<String> dividers;

  Section(this.label, this.bars, this.dividers);

  factory Section.fromString(String notation) {
    String? label;
    List<String> lines = notation.trim().split('\n');
    if (lines[0].startsWith(Section.labelLabel)) {
      label = lines[0].substring(Section.labelLabel.length).trim();
      lines.removeAt(0);
    }
    notation = lines.join();

    RegExp dividerParser = RegExp(r'(\|+)|(\[:)|(:\])');
    List<String> dividers = dividerParser
        .allMatches(notation)
        .expand((match) => match
            .groups([1, 2, 3])
            .where((divider) => divider != null)
            .map((divider) => divider as String))
        .toList();
    List<Bar> bars = notation
        .split(dividerParser)
        .map((divided) => divided.trim())
        .where((trimmed) => trimmed.isNotEmpty)
        .map(Bar.fromString)
        .toList();
    return Section(label, bars, dividers);
  }

  Section transpose(int steps) {
    for (var bar in bars) {
      bar.transpose(steps);
    }
    return this;
  }
}
