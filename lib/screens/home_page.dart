import 'package:chords/widgets/shakeable_container.dart';
import 'package:chords/widgets/sheet/sheet_editor.dart';
import 'package:chords/widgets/sheet/sheet_selector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String iconPath = 'assets/favicon.png';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final shakeableContainerKey = GlobalKey<ShakeableContainerState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Center(child: SheetSelector()),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.background,
            leading: Transform.scale(
              scale: 0.5,
              child: ImageIcon(AssetImage(HomePage.iconPath)),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.dashboard_customize),
                tooltip: "Custom",
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => SheetEditor(),
                ),
              ),
              SizedBox(width: 16.0),
            ],
          ),
        );
      },
    );
  }
}
