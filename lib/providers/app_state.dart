import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  Map<String, List<List<String>>> sections = {
    'A': [
      ['Am', 'D7'],
      ['Gmaj7'],
      ['Am', 'D7'],
      ['Am7'],
      ['D7'],
      ['Gmaj7'],
    ],
    'B': [
      ['Am', 'D7'],
      ['Gmaj7'],
      ['Am', 'D7'],
      ['Am7'],
    ],
    'Intro': [
      ['Am7'],
      ['D7'],
      ['Am7'],
      ['D7'],
    ],
    'Verse': [
      ['Am7'],
      ['D7'],
      ['Gm7', 'G#+'],
      ['Am7'],
      ['Gm7', 'C7'],
      ['Fmaj7', 'E7'],
      ['Am7'],
      ['D7'],
    ],
    'Chorus': [
      ['Cmaj7'],
      ['Fmaj7'],
      ['Cmaj7'],
      ['Fmaj7'],
      ['Cmaj7'],
      ['E7'],
    ],
  };
}
