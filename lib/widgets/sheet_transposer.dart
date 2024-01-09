import 'package:flutter/material.dart';

class SheetTransposer extends StatefulWidget {
  static const int ebInstrument = -3;
  static const int bbInstrument = 2;
  static const double minSlider = -6.0;
  static const double maxSlider = 6.0;
  static final int divisions = (minSlider.abs() + maxSlider).toInt();

  const SheetTransposer({
    super.key,
    required this.currentTranspose,
    required this.transposeSheet,
  });

  final int currentTranspose;
  final Function(int) transposeSheet;

  @override
  State<SheetTransposer> createState() => _SheetTransposerState();
}

class _SheetTransposerState extends State<SheetTransposer> {
  late int currentTranspose;
  late int currentSlider;

  void incrementSlider(int steps) {
    currentSlider += SheetTransposer.divisions ~/ 2 + steps;
    currentSlider %= SheetTransposer.divisions;
    currentSlider -= SheetTransposer.divisions ~/ 2;
  }

  void transposeSheet(int steps) {
    widget.transposeSheet(steps);
    currentTranspose += SheetTransposer.divisions ~/ 2 + steps;
    currentTranspose %= SheetTransposer.divisions;
    currentTranspose -= SheetTransposer.divisions ~/ 2;
  }

  @override
  void initState() {
    super.initState();
    currentTranspose = widget.currentTranspose;
    currentSlider = widget.currentTranspose;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StatefulBuilder(builder: (context, setState) {
      String sliderLabel = currentSlider.toInt().toString();
      if (currentSlider > 0) {
        sliderLabel = '+$sliderLabel';
      }
      if (currentSlider == SheetTransposer.ebInstrument) {
        sliderLabel += ' (Eb)';
      } else if (currentSlider == SheetTransposer.bbInstrument) {
        sliderLabel += ' (Bb)';
      }
      // hack to add spacing
      sliderLabel = '   $sliderLabel   ';

      return Container(
        height: 200,
        color: theme.cardColor,
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      incrementSlider(-1);
                      transposeSheet(-1);
                    });
                  },
                  icon: Icon(Icons.arrow_left_sharp),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Transpose',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      incrementSlider(1);
                      transposeSheet(1);
                    });
                  },
                  icon: Icon(Icons.arrow_right_sharp),
                ),
              ],
            ),
            SizedBox(height: 32),
            Slider(
              value: currentSlider.toDouble(),
              min: SheetTransposer.minSlider,
              max: SheetTransposer.maxSlider,
              divisions: SheetTransposer.divisions,
              inactiveColor: theme.colorScheme.outline,
              label: sliderLabel,
              onChanged: (sliderValue) {
                setState(() => currentSlider = sliderValue.round());
              },
              onChangeEnd: (sliderValue) {
                int steps = (sliderValue - currentTranspose).round();
                setState(() => transposeSheet(steps));
              },
            ),
          ],
        ),
      );
    });
  }
}
