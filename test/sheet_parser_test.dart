import 'package:chords/models/chord.dart';
import 'package:chords/models/sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parse sheet', () {
    String contents = '''
      info:
      title: Autumn Leaves
      composer: Joseph Kosma
      -----
      section: A
      [: Cm7 | F7    | Bbmaj7  | Ebmaj7  |
         Aø7 | D7b13 | Gm6     | Gm6    :]
      -----
      section: B
      || Aø7 | D7b13 | Gm6     | Gm6     |
         Cm7 | F7    | Bbmaj7  | Ebmaj7 ||
      -----
      section: C
      || Aø7 | D7b13 | Gm7 Gb7 | Fm7 E7  |
         Aø7 | D7b13 | Gm6     | Gm6    ||
    ''';
    Sheet sheet = Sheet.fromString(contents);
    expect(sheet.title, 'Autumn Leaves');
    expect(sheet.composer, 'Joseph Kosma');
    expect(sheet.sections.length, 3);
    expect(sheet.sections[0].bars[0].chords[0], Chord.fromString('Cm7'));
  });
}
