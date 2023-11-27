import 'package:chords/models/chord.dart';
import 'package:chords/widgets/bar_line.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chords/models/bar.dart';
import 'package:chords/models/section.dart';

void main() {
  test('Parse single bar lines', () {
    String notation = "| Am7 | D7 F7 | Gø7 C7 | Fm7 Bb7 |";
    Section section = Section.fromString(notation);

    for (String divider in section.dividers) {
      expect(divider, BarLine.singleBarLine);
    }

    List<Bar> expectedBars = [
      Bar([Chord.fromString("Am7")]),
      Bar([Chord.fromString("D7"), Chord.fromString("F7")]),
      Bar([Chord.fromString("Gø7"), Chord.fromString("C7")]),
      Bar([Chord.fromString("Fm7"), Chord.fromString("Bb7")]),
    ];
    expect(section.bars.length, expectedBars.length);
    for (int i = 0; i < section.bars.length; i++) {
      expect(section.bars[i], expectedBars[i]);
    }
  });

  test('Parse double bar lines', () {
    String notation = "| Am7 | D7 F7 || Gø7 C7 | Fm7 Bb7 ||";
    Section section = Section.fromString(notation);

    List<String> expectedDividers = [
      BarLine.singleBarLine,
      BarLine.singleBarLine,
      BarLine.doubleBarLine,
      BarLine.singleBarLine,
      BarLine.doubleBarLine,
    ];
    expect(section.dividers.length, expectedDividers.length);
    for (int i = 0; i < section.dividers.length; i++) {
      expect(section.dividers[i], expectedDividers[i]);
    }

    List<Bar> expectedBars = [
      Bar([Chord.fromString("Am7")]),
      Bar([Chord.fromString("D7"), Chord.fromString("F7")]),
      Bar([Chord.fromString("Gø7"), Chord.fromString("C7")]),
      Bar([Chord.fromString("Fm7"), Chord.fromString("Bb7")]),
    ];
    expect(section.bars.length, expectedBars.length);
    for (int i = 0; i < section.bars.length; i++) {
      expect(section.bars[i], expectedBars[i]);
    }
  });

  test('Parse repeat lines', () {
    String notation = "[: Am7 | D7 F7 :] Gø7 C7 | Fm7 Bb7 ||";
    Section section = Section.fromString(notation);

    List<String> expectedDividers = [
      BarLine.repeatBegin,
      BarLine.singleBarLine,
      BarLine.repeatEnd,
      BarLine.singleBarLine,
      BarLine.doubleBarLine,
    ];
    expect(section.dividers.length, expectedDividers.length);
    for (int i = 0; i < section.dividers.length; i++) {
      expect(section.dividers[i], expectedDividers[i]);
    }

    List<Bar> expectedBars = [
      Bar([Chord.fromString("Am7")]),
      Bar([Chord.fromString("D7"), Chord.fromString("F7")]),
      Bar([Chord.fromString("Gø7"), Chord.fromString("C7")]),
      Bar([Chord.fromString("Fm7"), Chord.fromString("Bb7")]),
    ];
    expect(section.bars.length, expectedBars.length);
    for (int i = 0; i < section.bars.length; i++) {
      expect(section.bars[i], expectedBars[i]);
    }
  });
}
