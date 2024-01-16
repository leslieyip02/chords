import 'package:chords/models/bar.dart';

class Section {
  static const String labelLabel = 'section:';

  const Section(
    this.label,
    this.bars,
    this.dividers,
    this.beatsPerBar,
  );

  final String? label;
  final List<Bar> bars;
  final List<String> dividers;
  final int beatsPerBar;

  factory Section.fromString(String notation, {int beatsPerBar = 4}) {
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
            .map((divider) => divider!))
        .toList();
    List<Bar> bars = notation
        .split(dividerParser)
        .map((divided) => divided.trim())
        .where((trimmed) => trimmed.isNotEmpty)
        .map((chunk) => Bar.fromString(chunk, beatsPerBar: beatsPerBar))
        .toList();
    return Section(label, bars, dividers, beatsPerBar);
  }

  Section transpose(int steps) {
    for (final bar in bars) {
      bar.transpose(steps);
    }
    return this;
  }

  Section autoAnnotate() {
    for (final bar in bars) {
      bar.autoAnnotate();
    }
    return this;
  }
}
