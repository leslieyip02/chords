import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/sheet_container.dart';

class SheetPage extends StatefulWidget {
  static const int maxBarsPerRow = 4;
  static const int navigateBack = 0;
  static const int navigateOptions = 1;

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
                    return Container(
                      height: 200,
                      color: theme.cardColor,
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(children: [
                              Text(
                                'Transpose',
                                textAlign: TextAlign.left,
                                style: theme.textTheme.titleMedium,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => setState(() {
                                      sheet = sheet?.transpose(-1);
                                    }),
                                    icon: Icon(Icons.arrow_drop_down),
                                    tooltip: 'Flatten',
                                  ),
                                  IconButton(
                                    onPressed: () => setState(() {
                                      sheet = sheet?.transpose(1);
                                    }),
                                    icon: Icon(Icons.arrow_drop_up),
                                    tooltip: 'Sharpen',
                                  ),
                                ],
                              ),
                            ]),
                          ],
                        ),
                      ),
                    );
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
