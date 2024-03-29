import 'package:chords/models/bar.dart';
import 'package:chords/models/section.dart';
import 'package:chords/widgets/bar/bar_line.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parse single bar lines', () {
    String notation = '| Am7 | D7 F7 | Gø7 C7 | Fm7 Bb7 |';
    Section section = Section.fromString(notation);

    for (final divider in section.dividers) {
      expect(divider, BarLine.singleBarLine);
    }

    List<Bar> expectedBars = [
      Bar.fromString('Am7'),
      Bar.fromString('D7 F7'),
      Bar.fromString('Gø7 C7'),
      Bar.fromString('Fm7 Bb7'),
    ];
    expect(section.bars.length, expectedBars.length);
    for (int i = 0; i < section.bars.length; i++) {
      expect(section.bars[i], expectedBars[i]);
    }
  });

  test('Parse double bar lines', () {
    String notation = '| Am7 | D7 F7 || Gø7 C7 | Fm7 Bb7 ||';
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
      Bar.fromString('Am7'),
      Bar.fromString('D7 F7'),
      Bar.fromString('Gø7 C7'),
      Bar.fromString('Fm7 Bb7'),
    ];
    expect(section.bars.length, expectedBars.length);
    for (int i = 0; i < section.bars.length; i++) {
      expect(section.bars[i], expectedBars[i]);
    }
  });

  test('Parse repeat lines', () {
    String notation = '[: Am7 | D7 F7 :] Gø7 C7 | Fm7 Bb7 ||';
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
      Bar.fromString('Am7'),
      Bar.fromString('D7 F7'),
      Bar.fromString('Gø7 C7'),
      Bar.fromString('Fm7 Bb7'),
    ];
    expect(section.bars.length, expectedBars.length);
    for (int i = 0; i < section.bars.length; i++) {
      expect(section.bars[i], expectedBars[i]);
    }
  });
}
