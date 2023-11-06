import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:chords/models/sheet.dart';
import 'package:chords/providers/app_state.dart';
import 'package:chords/widgets/sheet_container.dart';

class SheetPage extends StatefulWidget {
  static const int maxBarsPerRow = 4;
  static const int navigateBack = 0;
  static const int navigateOptions = 1;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var songPath = appState.sheetPath;

    final theme = Theme.of(context);

    void selectNavigationItem(int index) {
      if (index == SheetPage.navigateBack) {
        Navigator.pop(context);
      }
      setState(() => currentIndex = index);
    }

    return FutureBuilder<String>(
      future: rootBundle.loadString(songPath),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return Text('woops');
        }

        Sheet sheet = Sheet.fromString(snapshot.data as String);

        return LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              body: SheetContainer(sheet: sheet),
              bottomNavigationBar: BottomNavigationBar(
                // backgroundColor: theme.canvasColor,
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
                selectedItemColor: theme.colorScheme.primary,
                unselectedItemColor: theme.colorScheme.primary,
                onTap: selectNavigationItem,
              ),
            );
          },
        );
      },
    );
  }
}
