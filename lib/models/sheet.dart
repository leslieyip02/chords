import 'package:chords/models/section.dart';

class Sheet {
  static const String divider = '-----';
  static const String infoLabel = 'info:';
  static const String titleLabel = 'title:';
  static const String composerLabel = 'composer:';

  final String? title;
  final String? composer;
  final List<Section> sections;

  const Sheet(this.title, this.composer, this.sections);

  factory Sheet.fromString(String contents) {
    String? title;
    String? composer;
    List<String> divided = contents.split(Sheet.divider);
    if (divided.isEmpty) {
      throw ArgumentError('$contents is not a valid sheet');
    }

    if (divided[0].startsWith(Sheet.infoLabel)) {
      divided[0].split('\n').forEach((line) {
        if (line.startsWith(Sheet.titleLabel)) {
          title = line.substring(Sheet.titleLabel.length).trim();
        } else if (line.startsWith(Sheet.composerLabel)) {
          composer = line.substring(Sheet.composerLabel.length).trim();
        }
      });
      divided.removeAt(0);
    }

    List<Section> sections = divided.map(Section.fromString).toList();
    return Sheet(title, composer, sections);
  }
}
