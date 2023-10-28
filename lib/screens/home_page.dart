import 'package:chords/screens/sheet_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: theme.primaryColorLight,
                child: SheetPage(),
              ),
            ),
            SafeArea(
              child: BottomNavigationBar(
                backgroundColor: theme.canvasColor,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_music_rounded),
                    label: 'Sheet',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.manage_search),
                    label: 'Search',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
