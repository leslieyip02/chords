enum NoteValue { A, B, C, D, E, F, G }

class Note {
  const Note(
    this.value,
    this.isSharp,
    this.isFlat,
  );

  final NoteValue value;
  final bool isSharp;
  final bool isFlat;

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

  Note transpose(int steps) {
    if (steps == 0) {
      return this;
    }

    return steps > 0
        ? transposeUp().transpose(steps - 1)
        : transposeDown().transpose(steps + 1);
  }

  Note transposeUp() {
    if (isFlat) {
      return Note(
        value,
        false,
        false,
      );
    } else if (!isSharp) {
      if (value == NoteValue.B || value == NoteValue.E) {
        return Note(
          NoteValue.values[(value.index + 1) % NoteValue.values.length],
          false,
          false,
        );
      } else {
        return Note(
          value,
          true,
          false,
        );
      }
    } else {
      if (value == NoteValue.B || value == NoteValue.E) {
        return Note(
          NoteValue.values[(value.index + 1) % NoteValue.values.length],
          true,
          false,
        );
      } else {
        return Note(
          NoteValue.values[(value.index + 1) % NoteValue.values.length],
          false,
          false,
        );
      }
    }
  }

  Note transposeDown() {
    if (isSharp) {
      return Note(
        value,
        false,
        false,
      );
    } else if (!isFlat) {
      if (value == NoteValue.C || value == NoteValue.F) {
        return Note(
          NoteValue.values[(value.index - 1) % NoteValue.values.length],
          false,
          false,
        );
      } else {
        return Note(
          value,
          false,
          true,
        );
      }
    } else {
      if (value == NoteValue.C || value == NoteValue.F) {
        return Note(
          NoteValue.values[(value.index - 1) % NoteValue.values.length],
          false,
          true,
        );
      } else {
        return Note(
          NoteValue.values[(value.index - 1) % NoteValue.values.length],
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
        NoteValue.values[(value.index + 1) % NoteValue.values.length],
        false,
        !(value == NoteValue.B || value == NoteValue.E),
      );
    } else if (isFlat) {
      // e.g. Bb -> A#
      return Note(
        NoteValue.values[(value.index - 1) % NoteValue.values.length],
        !(value == NoteValue.C || value == NoteValue.F),
        false,
      );
    } else if (value == NoteValue.B || value == NoteValue.E) {
      // e.g. B -> Cb
      return Note(
        NoteValue.values[(value.index + 1) % NoteValue.values.length],
        false,
        true,
      );
    } else if (value == NoteValue.C || value == NoteValue.F) {
      // e.g. C -> B#
      return Note(
        NoteValue.values[(value.index - 1) % NoteValue.values.length],
        true,
        false,
      );
    }
    return this;
  }

  @override
  String toString() {
    String notation = String.fromCharCode(value.index + 65);
    if (isSharp) {
      notation += '#';
    } else if (isFlat) {
      notation += 'b';
    }
    return notation;
  }

  @override
  int get hashCode => Object.hash(value, isSharp, isFlat);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
