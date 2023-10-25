enum NoteValue { A, B, C, D, E, F, G }

class Note {
  final NoteValue noteValue;
  final bool isSharp;
  final bool isFlat;

  Note(this.noteValue, this.isSharp, this.isFlat);

  factory Note.fromString(String notation) {
    int index = notation.codeUnitAt(0) - 65;
    if (index > NoteValue.values.length) {
      throw RangeError('$notation is not a valid note');
    }

    return Note(
      NoteValue.values[notation.codeUnitAt(0) - 65],
      notation.length > 1 && notation[1] == '#',
      notation.length > 1 && notation[1] == 'b',
    );
  }

  Note transposeUp() {
    if (isFlat) {
      return Note(
        noteValue,
        false,
        false,
      );
    } else if (!isSharp) {
      if (noteValue == NoteValue.B || noteValue == NoteValue.E) {
        return Note(
          NoteValue.values[(noteValue.index + 1) % NoteValue.values.length],
          false,
          false,
        );
      } else {
        return Note(
          noteValue,
          true,
          false,
        );
      }
    } else {
      if (noteValue == NoteValue.B || noteValue == NoteValue.E) {
        return Note(
          NoteValue.values[(noteValue.index + 1) % NoteValue.values.length],
          true,
          false,
        );
      } else {
        return Note(
          NoteValue.values[(noteValue.index + 1) % NoteValue.values.length],
          false,
          false,
        );
      }
    }
  }

  Note transposeDown() {
    if (isSharp) {
      return Note(
        noteValue,
        false,
        false,
      );
    } else if (!isFlat) {
      if (noteValue == NoteValue.C || noteValue == NoteValue.F) {
        return Note(
          NoteValue.values[(noteValue.index - 1) % NoteValue.values.length],
          false,
          false,
        );
      } else {
        return Note(
          noteValue,
          false,
          true,
        );
      }
    } else {
      if (noteValue == NoteValue.C || noteValue == NoteValue.F) {
        return Note(
          NoteValue.values[(noteValue.index - 1) % NoteValue.values.length],
          false,
          true,
        );
      } else {
        return Note(
          NoteValue.values[(noteValue.index - 1) % NoteValue.values.length],
          false,
          false,
        );
      }
    }
  }

  Note toggleEnharmonic() {
    if (isSharp) {
      // e.g. A# -> Bb
      return Note(
        NoteValue.values[(noteValue.index + 1) % NoteValue.values.length],
        false,
        !(noteValue == NoteValue.B || noteValue == NoteValue.E),
      );
    } else if (isFlat) {
      // e.g. Bb -> A#
      return Note(
        NoteValue.values[(noteValue.index - 1) % NoteValue.values.length],
        !(noteValue == NoteValue.C || noteValue == NoteValue.F),
        false,
      );
    } else if (noteValue == NoteValue.B || noteValue == NoteValue.E) {
      // e.g. B -> Cb
      return Note(
        NoteValue.values[(noteValue.index + 1) % NoteValue.values.length],
        false,
        true,
      );
    } else if (noteValue == NoteValue.C || noteValue == NoteValue.F) {
      // e.g. C -> B#
      return Note(
        NoteValue.values[(noteValue.index - 1) % NoteValue.values.length],
        true,
        false,
      );
    }
    return this;
  }

  @override
  String toString() {
    String notation = String.fromCharCode(noteValue.index + 65);
    if (isSharp) {
      notation += '#';
    } else if (isFlat) {
      notation += 'b';
    }
    return notation;
  }
}
