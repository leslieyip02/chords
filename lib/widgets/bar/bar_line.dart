import 'package:chords/main.dart';
import 'package:chords/widgets/chord/chord_card.dart';
import 'package:chords/widgets/sheet/sheet_row.dart';
import 'package:flutter/material.dart';

abstract class BarLine extends StatelessWidget {
  static const String singleBarLine = '|';
  static const String doubleBarLine = '||';
  static const String repeatBegin = '[:';
  static const String repeatEnd = ':]';
  static const barLineWidth = ChordCard.margin / 2;
  static const containerWidth = BarLine.barLineWidth * 3;

  const BarLine({
    super.key,
  });

  factory BarLine.of(String notation) {
    if (notation == BarLine.singleBarLine) {
      return SingleBarLine();
    } else if (notation == BarLine.doubleBarLine) {
      return DoubleBarLine();
    } else if (notation == BarLine.repeatBegin ||
        notation == BarLine.repeatEnd) {
      return RepeatBarLine.fromString(notation);
    } else {
      throw ArgumentError('$notation is not a valid barline');
    }
  }

  static Widget line(BuildContext context) {
    return SizedBox(
      height: SheetRow.getRowHeight(context),
      width: BarLine.barLineWidth,
      child: Container(color: App.colorScheme.outline),
    );
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
      margin: EdgeInsets.symmetric(horizontal: ChordCard.margin),
      child: Center(child: BarLine.line(context)),
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
      margin: EdgeInsets.symmetric(horizontal: ChordCard.margin),
      child: Row(
        children: [
          BarLine.line(context),
          SizedBox(width: BarLine.barLineWidth),
          BarLine.line(context),
        ],
      ),
    );
  }
}

class RepeatBarLine extends BarLine {
  const RepeatBarLine({
    super.key,
    required this.alignment,
  });

  final CrossAxisAlignment alignment;

  factory RepeatBarLine.fromString(String notation) {
    return RepeatBarLine(
      alignment: notation == BarLine.repeatBegin
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
    );
  }

  static Widget dash = Container(
    width: BarLine.containerWidth,
    height: BarLine.barLineWidth,
    color: App.colorScheme.outline,
  );

  static Widget stem = Container(
    width: BarLine.barLineWidth,
    height: BarLine.containerWidth * 3,
    color: App.colorScheme.outline,
  );

  static Widget dot = Container(
    width: BarLine.barLineWidth * 1.5,
    height: BarLine.barLineWidth * 1.5,
    color: App.colorScheme.outline,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ChordCard.margin),
      child: SizedBox(
        width: BarLine.containerWidth,
        height: SheetRow.getRowHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: alignment,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: alignment,
              children: [RepeatBarLine.dash, RepeatBarLine.stem],
            ),
            Column(
              children: [
                RepeatBarLine.dot,
                SizedBox(height: BarLine.barLineWidth * 2),
                RepeatBarLine.dot
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: alignment,
              children: [RepeatBarLine.stem, RepeatBarLine.dash],
            ),
          ],
        ),
      ),
    );
  }
}
