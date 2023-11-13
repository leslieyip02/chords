import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/sheet_container.dart';

class SheetPage extends StatefulWidget {
  static const int maxBarsPerRow = 4;
  static const int navigateBack = 0;
  static const int navigateOptions = 1;
  static const int ebInstrument = -3;
  static const int bbInstrument = 2;

  const SheetPage({
    super.key,
    required this.songPath,
  });

  final String songPath;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  int currentIndex = 0;
  double currentSlider = 0.0;
  int currentTranpose = 0;
  Sheet? sheet;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString(widget.songPath).then((value) {
      sheet = Sheet.fromString(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (sheet == null) {
      return Text('woops');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SheetContainer(sheet: sheet as Sheet),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: theme.secondaryHeaderColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_circle_left_outlined),
                label: 'Back',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Options',
              ),
            ],
            currentIndex: currentIndex,
            selectedItemColor: theme.primaryColor,
            unselectedItemColor: theme.primaryColor,
            onTap: (index) {
              if (index == SheetPage.navigateBack) {
                Navigator.pop(context);
              } else if (index == SheetPage.navigateOptions) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, nestedSetState) {
                      String sliderLabel = currentSlider.toInt().toString();
                      if (currentSlider > 0) {
                        sliderLabel = '+$sliderLabel';
                      }
                      if (currentSlider == SheetPage.ebInstrument) {
                        sliderLabel += ' (Eb)';
                      } else if (currentSlider == SheetPage.bbInstrument) {
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
                            Text(
                              'Transpose',
                              textAlign: TextAlign.left,
                              style: theme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 32),
                            Slider(
                              value: currentSlider,
                              min: -6,
                              max: 6,
                              divisions: 12,
                              label: sliderLabel,
                              onChanged: (value) {
                                nestedSetState(() {
                                  currentSlider = value;
                                });
                              },
                              onChangeEnd: (value) {
                                setState(() {
                                  sheet = sheet?.transpose(
                                      value.toInt() - currentTranpose);
                                  currentTranpose = value.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              }
              setState(() => currentIndex = index);
            },
          ),
        );
      },
    );
  }
}
