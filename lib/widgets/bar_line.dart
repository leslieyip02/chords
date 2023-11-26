import 'package:chords/main.dart';
import 'package:chords/models/bar.dart';
import 'package:chords/widgets/chord_card.dart';
import 'package:chords/widgets/sheet_row.dart';
import 'package:flutter/material.dart';

abstract class BarLine extends StatelessWidget {
  static const containerWidth = 6.0;
  static const barLineWidth = 2.0;

  // static Widget line = Container(
  //   height: SheetRow.rowHeight,
  //   width: BarLine.containerWidth,
  //   color: App.colorScheme.outline,
  // );
  static Widget line = SizedBox(
    height: SheetRow.rowHeight,
    width: BarLine.barLineWidth,
    child: Container(
      color: App.colorScheme.outline,
    ),
  );

  const BarLine({
    super.key,
  });

  factory BarLine.of(String notation) {
    if (notation == Bar.singleBarLine) {
      return SingleBarLine();
    } else if (notation == Bar.doubleBarLine) {
      return DoubleBarLine();
    } else if (notation == Bar.repeatBegin) {
      // TODO: implement this
      return DoubleBarLine();
    } else if (notation == Bar.repeatEnd) {
      // TODO: implement this
      return DoubleBarLine();
    } else {
      throw ArgumentError('$notation is not a valid barline');
    }
  }
}

class SingleBarLine extends BarLine {
  const SingleBarLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BarLine.containerWidth,
      margin: EdgeInsets.symmetric(horizontal: ChordCard.margin / 2),
      child: Center(
        child: BarLine.line,
      ),
    );
  }
}

class DoubleBarLine extends BarLine {
  const DoubleBarLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BarLine.containerWidth,
      margin: EdgeInsets.symmetric(horizontal: ChordCard.margin / 2),
      child: Row(children: [
        BarLine.line,
        SizedBox(width: BarLine.barLineWidth),
        BarLine.line,
      ]),
    );
  }
}
