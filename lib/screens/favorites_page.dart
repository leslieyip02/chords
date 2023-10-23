import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chords/providers/app_state.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'You have '
              '${appState.favorites.length} favorite(s):',
              textScaleFactor: 1.8,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          for (var pair in appState.favorites)
            ListTile(
                title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite),
                SizedBox(width: 10),
                Text(pair.asLowerCase),
              ],
            )),
        ],
      ),
    );
  }
}
