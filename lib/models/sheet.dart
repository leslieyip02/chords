import 'package:chords/models/section.dart';

class Sheet {
  final String title;
  final String composer;
  final List<Section> sections;

  Sheet(this.title, this.composer, this.sections);

  factory Sheet.fromString(String contents) {
    List<Section> sections = contents
        .replaceAll('\r', '')
        .split('\n\n')
        .map(Section.fromString)
        .toList();
    return Sheet('Title', 'Composer', sections);
  }
}
