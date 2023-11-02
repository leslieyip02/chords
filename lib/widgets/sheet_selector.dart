import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chords/providers/app_state.dart';
import 'package:chords/screens/sheet_page.dart';

class SheetSelector extends StatelessWidget {
  static const String pathDoesNotExist = '';

  const SheetSelector({
    super.key,
  });

  void selectSheet(String path, BuildContext context) {
    if (path != SheetSelector.pathDoesNotExist) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SheetPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

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

        return SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () => controller.openView(),
              onChanged: (_) => controller.openView(),
              onSubmitted: (selectedPath) {
                selectSheet(
                    paths.contains(selectedPath)
                        ? selectedPath
                        : SheetSelector.pathDoesNotExist,
                    context);
              },
              leading: Icon(Icons.search),
              trailing: [
                Tooltip(
                  message: 'Search',
                  child: IconButton(
                    onPressed: () => selectSheet(appState.sheetPath, context),
                    icon: Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ],
            );
          },
          suggestionsBuilder:
              (BuildContext context, SearchController controller) {
            return paths.map(
              (path) => ListTile(
                leading: Icon(Icons.music_note),
                title: Text(path),
                onTap: () {
                  appState.setSongPath(path);
                  controller.closeView(path);
                },
              ),
            );
          },
        );
      },
    );
  }
}
