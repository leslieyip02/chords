import 'dart:convert';
import 'package:chords/widgets/shakeable_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chords/providers/app_state.dart';
import 'package:chords/screens/sheet_page.dart';

class SheetSelector extends StatefulWidget {
  static const String pathPrefix = 'assets/sheets/';
  static const String pathSuffix = '.txt';

  @override
  State<SheetSelector> createState() => _SheetSelectorState();
}

class _SheetSelectorState extends State<SheetSelector> {
  final shakeableContainerKey = GlobalKey<ShakeableContainerState>();
  late List<String> paths;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    void selectSheet(String path) {
      path = path.toLowerCase().replaceAll(' ', '_');
      if (!path.startsWith(SheetSelector.pathPrefix)) {
        path = SheetSelector.pathPrefix + path;
      }
      if (!path.endsWith(SheetSelector.pathSuffix)) {
        path = path + SheetSelector.pathSuffix;
      }
      if (paths.contains(path)) {
        appState.setSheetPath(path);
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => SheetPage(songPath: path)));
      } else {
        shakeableContainerKey.currentState?.shake();
      }
    }

    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('AssetManifest.json'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return Text('woops');
        }

        Map<String, dynamic> pathMap = jsonDecode(snapshot.data as String);
        paths = pathMap.keys
            .where((path) => path.startsWith(SheetSelector.pathPrefix))
            .toList();

        return ShakeableContainer(
          key: shakeableContainerKey,
          child: Container(
            margin: EdgeInsets.all(64.0),
            child: SearchAnchor(
              viewConstraints: BoxConstraints(maxHeight: 300.0),
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () => controller.openView(),
                  onChanged: (_) => controller.openView(),
                  onSubmitted: (selectedPath) => selectSheet(selectedPath),
                  leading: Icon(Icons.search),
                  trailing: [
                    Tooltip(
                      message: 'Search',
                      child: IconButton(
                        onPressed: () => selectSheet(controller.value.text),
                        icon: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ],
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return paths.map((path) {
                  String title = path
                      .replaceAll(SheetSelector.pathPrefix, '')
                      .replaceAll(SheetSelector.pathSuffix, '')
                      .split('_')
                      .map((word) =>
                          '${word[0].toUpperCase()}${word.substring(1)}')
                      .join(' ');
                  return ListTile(
                    leading: Icon(Icons.music_note),
                    title: Text(title),
                    onTap: () => controller.closeView(title),
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }
}
