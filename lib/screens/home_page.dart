import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chords/screens/sheet_page.dart';
import 'package:chords/providers/app_state.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    final theme = Theme.of(context);

    void menuOnSelect(String path) {
      appState.setSongPath(path);
    }

    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('AssetManifest.json'),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return Text('woops');
        }

        final Map<String, dynamic> pathMap =
            jsonDecode(snapshot.data as String);
        final List<String> paths = pathMap.keys
            .where((path) => path.startsWith('assets/sheets'))
            .toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownMenu(
                      dropdownMenuEntries: [
                        for (final (index, path) in paths.indexed)
                          DropdownMenuEntry(value: index, label: path),
                      ],
                      onSelected: (index) => menuOnSelect(paths[index as int]),
                    ),
                    SizedBox(width: 16.0),
                    Ink(
                      decoration: ShapeDecoration(
                        color: theme.primaryColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        iconSize: 24.0,
                        color: theme.colorScheme.onPrimary,
                        onPressed: () {
                          if (appState.songPath.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SheetPage()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
