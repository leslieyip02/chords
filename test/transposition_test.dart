import 'package:chords/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Transpose up', () {
    Note a = Note.fromString('A');
    expect(a.transposeUp(), Note.fromString('A#'));
  });

  test('Transpose down', () {
    Note a = Note.fromString('A');
    expect(a.transposeDown(), Note.fromString('Ab'));
  });

  test('Transpose up by steps', () {
    Note a = Note.fromString('A');

    List<String> notations = [
      'A',
      'A#',
      'B',
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
    ];

    for (final (steps, notation) in notations.indexed) {
      expect(a.transpose(steps), Note.fromString(notation));
    }
  });

  test('Transpose down by steps', () {
    Note a = Note.fromString('A');

    List<String> notations = [
      'A',
      'Ab',
      'G',
      'Gb',
      'F',
      'E',
      'Eb',
      'D',
      'Db',
      'C',
      'B',
      'Bb',
      'A',
    ];

    for (final (steps, notation) in notations.indexed) {
      expect(a.transpose(-steps), Note.fromString(notation));
    }
  });
}
