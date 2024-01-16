import 'package:chords/models/section.dart';

class Sheet {
  static const String divider = '-----';
  static const String infoLabel = 'info:';
  static const String titleLabel = 'title:';
  static const String composerLabel = 'composer:';
  static const String timeSignatureLabel = 'time:';

  const Sheet(
    this.title,
    this.composer,
    this.sections,
    this.originalContents,
    this.beatsPerBar,
  );

  final String? title;
  final String? composer;
  final List<Section> sections;
  final String originalContents;
  final int beatsPerBar;

  factory Sheet.fromString(String contents) {
    String? title;
    String? composer;
    // default to 4/4
    int beatsPerBar = 4;
    List<String> divided = contents
        .split(Sheet.divider)
        .map((division) => division.trim())
        .toList();
    if (divided.isEmpty) {
      throw ArgumentError('$contents is not a valid sheet');
    }

    if (divided[0].startsWith(Sheet.infoLabel)) {
      divided[0].split('\n').forEach((line) {
        line = line.trim();
        if (line.startsWith(Sheet.titleLabel)) {
          title = line.substring(Sheet.titleLabel.length).trim();
        } else if (line.startsWith(Sheet.composerLabel)) {
          composer = line.substring(Sheet.composerLabel.length).trim();
        } else if (line.startsWith(Sheet.timeSignatureLabel)) {
          String timeSignature = line
              .substring(
                Sheet.timeSignatureLabel.length,
              )
              .trim();
          try {
            var [beats, _] = timeSignature.split('/');
            beatsPerBar = int.tryParse(beats)!;
          } catch (_) {
            throw ArgumentError('$timeSignature is not a valid time signature');
          }
        }
      });
      divided.removeAt(0);
    }

    List<Section> sections = divided.map((chunk) {
      return Section.fromString(chunk, beatsPerBar: beatsPerBar);
    }).toList();
    return Sheet(title, composer, sections, contents, beatsPerBar);
  }

  Sheet reset() {
    List<Section> resetSections = Sheet.fromString(originalContents).sections;
    for (int i = 0; i < resetSections.length; i++) {
      sections[i] = resetSections[i];
    }
    return this;
  }

  Sheet transpose(int steps) {
    for (final section in sections) {
      section.transpose(steps);
    }
    return this;
  }

  Sheet autoAnnotate() {
    for (final section in sections) {
      section.autoAnnotate();
    }
    return this;
  }
}
