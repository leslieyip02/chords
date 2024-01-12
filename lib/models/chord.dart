import 'package:chords/models/note.dart';

class Chord {
  // semitone displacement
  static const Map<int, int> degreeDisplacements = {
    2: 2,
    4: 5,
    5: 7,
    6: 9,
    7: 11,
  };
  static const Map<String, List<int>> chordToneDisplacements = {
    '': [0, 4, 7],
    'm': [0, 3, 7],
    'maj7': [0, 4, 7, 11],
    '7': [0, 4, 7, 10],
    'm7': [0, 3, 7, 10],
    'min7': [0, 3, 7, 10],
    'ø7': [0, 3, 6, 10],
    'm7b5': [0, 3, 6, 10],
    'o7': [0, 3, 6, 9],
    'dim7': [0, 3, 6, 9],
  };
  static final List<Note> preferSharpKeys = [
    Note.fromString('B'),
    Note.fromString('E'),
    Note.fromString('A'),
    Note.fromString('D'),
    Note.fromString('G'),
  ];

  Chord(
    this.note,
    this.quality,
    this.originalNotation,
  );

  Note note;
  String quality;
  String originalNotation;
  String? annotation;

  factory Chord.fromString(String notation) {
    RegExp parser = RegExp(r'([A-G][#b]?)(.*)?');
    RegExpMatch? match = parser.firstMatch(notation.trim());
    if (match?.group(1) == null) {
      throw ArgumentError('$notation is not a valid chord');
    }
    Note note = Note.fromString(match?.group(1) as String);
    String quality = match?.group(2) ?? '';
    return Chord(note, quality, notation);
  }

  void update(String notation) {
    Chord updated = Chord.fromString(notation);
    note = updated.note;
    quality = updated.quality;
  }

  void reset() {
    update(originalNotation);
    annotation = null;
  }

  Chord transpose(int steps) {
    note = note.transpose(steps);
    return this;
  }

  Chord toggleEnharmonic() {
    note = note.toggleEnharmonic();
    return this;
  }

  List<Note> arpeggiate() {
    // TODO: finish this
    List<Note> chordTones = [];
    List<int> displacements = [];
    String qualityPrefix = '';
    for (final prefix in chordToneDisplacements.keys) {
      if (quality.startsWith(prefix) && prefix.length > qualityPrefix.length) {
        qualityPrefix = prefix;
      }
    }
    displacements.addAll(Chord.chordToneDisplacements[qualityPrefix]!);

    String qualitySuffix = quality.substring(qualityPrefix.length);
    bool sharpened = false;
    bool flattened = false;
    RegExp digitMatcher = RegExp(r'\d+');
    int suffixIndex = 0;
    while (suffixIndex < qualitySuffix.length) {
      if (qualitySuffix[suffixIndex] == '#') {
        sharpened = true;
        suffixIndex += 1;
      } else if (qualitySuffix[suffixIndex] == 'b') {
        flattened = true;
        suffixIndex += 1;
      } else if (qualitySuffix[suffixIndex] == '/') {
        String bass = qualitySuffix.substring(suffixIndex + 1);
        chordTones.add(Note.fromString(bass));
        break;
      }

      String digits = qualitySuffix.substring(suffixIndex);
      RegExpMatch? match = digitMatcher.firstMatch(digits);
      if (match != null) {
        int? degree = int.tryParse(match.group(0) ?? '');
        print(degree);
        if (degree != null) {
          if (degree > 7) {
            degree -= 7;
          }
          int degreeIndex = displacements.indexOf(degreeDisplacements[degree]!);
          if (degreeIndex == -1) {
            displacements.add(degreeDisplacements[degree]!);
            degreeIndex = displacements.length - 1;
          }
          if (sharpened) {
            displacements[degreeIndex]++;
            sharpened = false;
          } else if (flattened) {
            displacements[degreeIndex]--;
            flattened = false;
          }
        }
        suffixIndex = match.end;
      }
      suffixIndex++;
    }

    // TODO: prefer flats over sharps (but only sometimes)
    bool preferFlat = !Chord.preferSharpKeys.contains(note);
    for (final displacement in displacements) {
      Note chordTone = note.transpose(displacement);
      if (chordTone.isSharp && preferFlat) {
        chordTone = chordTone.toggleEnharmonic();
      }
      chordTones.add(chordTone);
    }
    return chordTones;

    // TODO: make tests for loading all sheets
  }

  void autoAnnoate() {
    final chordTones = arpeggiate();
    annotation = chordTones.map((note) => note.toString()).join('-');
  }

  @override
  String toString() {
    return note.toString() + quality;
  }

  @override
  int get hashCode => Object.hash(note, quality);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
