import 'package:chords/models/bar.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/models/sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Reset chord', () {
    Chord a = Chord.fromString('Amaj7');
    a.update('Bmin7');
    expect(a, Chord.fromString('Bmin7'));
    a.reset();
    expect(a, Chord.fromString('Amaj7'));
  });

  test('Reset transposed chord', () {
    Chord a = Chord.fromString('Amaj7');
    a.update('Bmin7');
    expect(a, Chord.fromString('Bmin7'));
    a.transpose(5);
    expect(a, Chord.fromString('Emin7'));
    a.reset();
    expect(a, Chord.fromString('Dmaj7'));
  });

  test('Reset sheet', () {
    String originalNotation = '|| Amaj7 | Bmin7 ||';
    Sheet sheet = Sheet.fromString(originalNotation);
    expect(sheet.sections[0].bars[0], Bar.fromString('Amaj7'));
    expect(sheet.sections[0].bars[1], Bar.fromString('Bmin7'));
    sheet.transpose(5);
    expect(sheet.sections[0].bars[0], Bar.fromString('Dmaj7'));
    expect(sheet.sections[0].bars[1], Bar.fromString('Emin7'));
    sheet.reset();
    expect(sheet.sections[0].bars[0], Bar.fromString('Amaj7'));
    expect(sheet.sections[0].bars[1], Bar.fromString('Bmin7'));
  });
}
