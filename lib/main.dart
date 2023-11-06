import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chords/providers/app_state.dart';
import 'package:chords/screens/home_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.lightBlue,
    primary: Color(0xFF66A4EF),
  );

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Chords',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
        ),
        home: HomePage(),
      ),
    );
  }
}
