import 'dart:convert';
import 'package:chords/screens/sheet_page.dart';
import 'package:chords/widgets/shakeable_container.dart';
import 'package:flutter/material.dart';

class SheetSelector extends StatefulWidget {
  static const String pathPrefix = 'assets/sheets/';
  static const String pathSuffix = '.txt';

  @override
  State<SheetSelector> createState() => _SheetSelectorState();
}

class _SheetSelectorState extends State<SheetSelector> {
  final shakeableContainerKey = GlobalKey<ShakeableContainerState>();
  late List<String> paths;

  void selectSheet(String path) {
    path = path.toLowerCase().replaceAll(' ', '_');
    if (!path.startsWith(SheetSelector.pathPrefix)) {
      path = SheetSelector.pathPrefix + path;
    }
    if (!path.endsWith(SheetSelector.pathSuffix)) {
      path = path + SheetSelector.pathSuffix;
    }
    if (paths.contains(path)) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => SheetPage(songPath: path)));
    } else {
      shakeableContainerKey.currentState?.shake();
    }
  }

  String truncatePath(String path) {
    final Iterable<String> words = path
        .replaceAll(SheetSelector.pathPrefix, '')
        .replaceAll(SheetSelector.pathSuffix, '')
        .split('_');

    return words.map((word) {
      // check for abbreviations (i.e. Mr P.C.)
      final letters = word.split('.').where((letter) => letter.isNotEmpty);
      if (letters.length > 1) {
        return letters.map((letter) => '${letter.toUpperCase()}.').join('');
      } else {
        // capitalise every word by default
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double margin = width <= SheetPage.narrowThreshold ? 24.0 : 64.0;

    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('AssetManifest.json'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          // placeholder
          return Container();
        }

        Map<String, dynamic> pathMap = jsonDecode(snapshot.data!);
        paths = pathMap.keys
            .where((path) => path.startsWith(SheetSelector.pathPrefix))
            .toList();

        return ShakeableContainer(
          key: shakeableContainerKey,
          child: Container(
            margin: EdgeInsets.all(margin),
            child: SearchAnchor(
              viewConstraints: BoxConstraints(maxHeight: 300.0),
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
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
              suggestionsBuilder: (
                BuildContext context,
                SearchController controller,
              ) {
                return paths
                    .map(truncatePath)
                    .where((title) => title
                        .toLowerCase()
                        .startsWith(controller.value.text.toLowerCase()))
                    .map((title) => ListTile(
                        leading: Icon(Icons.music_note),
                        title: Text(title),
                        onTap: () => controller.closeView(title)));
              },
            ),
          ),
        );
      },
    );
  }
}
