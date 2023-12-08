import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/sheet_container.dart';

class SheetPage extends StatefulWidget {
  static const int maxBarsPerRowWide = 4;
  static const int maxBarsPerRowNarrow = 2;
  static const double narrowThreshold = 600;
  static const int navigateBack = 0;
  static const int navigateOptions = 1;
  static const int ebInstrument = -3;
  static const int bbInstrument = 2;
  static const double minSlider = -6.0;
  static const double maxSlider = 6.0;

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
      // placeholder
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SheetContainer(sheet: sheet as Sheet),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.background,
            leading: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return IconButton(
                icon: Icon(Icons.arrow_back),
                tooltip: "Back",
                onPressed: () => Navigator.pop(context),
              );
            }),
            actions: [
              IconButton(
                icon: Icon(Icons.restart_alt),
                tooltip: "Reset",
                onPressed: () => setState(() {
                  // hack
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              SheetPage(songPath: widget.songPath)));
                }),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: IconButton(
                  icon: Icon(Icons.more_vert),
                  tooltip: "Transpose",
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (context, nestedSetState) {
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (currentSlider > SheetPage.minSlider) {
                                        setState(() {
                                          sheet = sheet?.transpose(-1);
                                          currentTranpose--;
                                        });
                                        nestedSetState(() {
                                          currentSlider--;
                                        });
                                      }
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
                                      if (currentSlider < SheetPage.maxSlider) {
                                        setState(() {
                                          sheet = sheet?.transpose(1);
                                          currentTranpose++;
                                        });
                                        nestedSetState(() {
                                          currentSlider++;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.arrow_right_sharp),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32),
                              Slider(
                                value: currentSlider,
                                min: SheetPage.minSlider,
                                max: SheetPage.maxSlider,
                                divisions: (SheetPage.minSlider.abs() +
                                        SheetPage.maxSlider)
                                    .round(),
                                inactiveColor: theme.colorScheme.outline,
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
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
