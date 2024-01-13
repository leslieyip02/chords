import 'package:chords/models/chord.dart';
import 'package:chords/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Major chords', () {
    List<Note> chordTones = [
      Note.fromString('A'),
      Note.fromString('C#'),
      Note.fromString('E'),
    ];
    expect(Chord.fromString('A').arpeggiate(), chordTones);
    expect(Chord.fromString('Amaj').arpeggiate(), chordTones);

    chordTones.add(Note.fromString('G#'));
    expect(Chord.fromString('Amaj7').arpeggiate(), chordTones);
  });

  test('Dominant chord', () {
    List<Note> chordTones = [
      Note.fromString('A'),
      Note.fromString('C#'),
      Note.fromString('E'),
      Note.fromString('G'),
    ];
    expect(Chord.fromString('A7').arpeggiate(), chordTones);
  });

  test('Minor chords', () {
    List<Note> chordTones = [
      Note.fromString('A'),
      Note.fromString('C'),
      Note.fromString('E'),
    ];
    expect(Chord.fromString('A-').arpeggiate(), chordTones);
    expect(Chord.fromString('Am').arpeggiate(), chordTones);
    expect(Chord.fromString('Amin').arpeggiate(), chordTones);

    chordTones.add(Note.fromString('G'));
    expect(Chord.fromString('A-7').arpeggiate(), chordTones);
    expect(Chord.fromString('Am7').arpeggiate(), chordTones);
    expect(Chord.fromString('Amin7').arpeggiate(), chordTones);
  });

  test('Half diminished chords', () {
    List<Note> chordTones = [
      Note.fromString('A'),
      Note.fromString('C'),
      Note.fromString('D#'),
      Note.fromString('G'),
    ];
    expect(Chord.fromString('Aø7').arpeggiate(), chordTones);
    expect(Chord.fromString('A-7b5').arpeggiate(), chordTones);
    expect(Chord.fromString('Am7b5').arpeggiate(), chordTones);
    expect(Chord.fromString('Amin7b5').arpeggiate(), chordTones);
  });

  test('Diminished chords', () {
    List<Note> chordTones = [
      Note.fromString('A'),
      Note.fromString('C'),
      Note.fromString('D#'),
    ];
    expect(Chord.fromString('Ao').arpeggiate(), chordTones);
    expect(Chord.fromString('Adim').arpeggiate(), chordTones);

    chordTones.add(Note.fromString('F#'));
    expect(Chord.fromString('Ao7').arpeggiate(), chordTones);
    expect(Chord.fromString('Adim7').arpeggiate(), chordTones);
  });

  test('Suspended chords', () {
    List<Note> chordTones = [
      Note.fromString('A'),
      Note.fromString('D'),
      Note.fromString('E'),
    ];
    expect(Chord.fromString('Asus').arpeggiate(), chordTones);

    chordTones[1] = Note.fromString('B');
    expect(Chord.fromString('Asus2').arpeggiate(), chordTones);

    chordTones[1] = Note.fromString('D');
    chordTones.add(Note.fromString('B'));
    expect(Chord.fromString('A9sus4').arpeggiate(), chordTones);
  });

  test('Chord extensions', () {
    List<Note> chordTones = [
      Note.fromString('A'),
      Note.fromString('C#'),
      Note.fromString('E'),
      Note.fromString('F#'),
    ];
    expect(Chord.fromString('A6').arpeggiate(), chordTones);

    chordTones[1] = Note.fromString('C');
    expect(Chord.fromString('Am6').arpeggiate(), chordTones);

    chordTones = [
      Note.fromString('A'),
      Note.fromString('C#'),
      Note.fromString('E'),
      Note.fromString('G'),
      Note.fromString('D#'),
    ];
    expect(Chord.fromString('A7#11').arpeggiate(), chordTones);

    chordTones = [
      Note.fromString('A'),
      Note.fromString('C#'),
      Note.fromString('D#'),
      Note.fromString('G'),
      Note.fromString('A#'),
    ];
    expect(Chord.fromString('A7b5b9').arpeggiate(), chordTones);
  });

  test('Slash chords', () {
    List<Note> chordTones = [
      Note.fromString('G'),
      Note.fromString('A'),
      Note.fromString('C#'),
      Note.fromString('E'),
    ];
    expect(Chord.fromString('A/G').arpeggiate(), chordTones);

    chordTones = [
      Note.fromString('A'),
      Note.fromString('C#'),
      Note.fromString('E'),
      Note.fromString('F#'),
      Note.fromString('B'),
    ];
    expect(Chord.fromString('A6/9').arpeggiate(), chordTones);
  });
}
