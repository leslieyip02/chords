import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chords/providers/app_state.dart';
import 'package:chords/screens/home_page.dart';
import 'package:chords/screens/sheet_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static ColorScheme colorScheme = ColorScheme.dark(
    primary: Color(0xFFAE81FF),
    secondary: Color.fromARGB(255, 200, 200, 200),
    surface: Color.fromARGB(255, 40, 40, 40),
    onSurface: Color.fromARGB(255, 200, 200, 200),
    outline: Color.fromARGB(255, 200, 200, 200),
    onBackground: Color.fromARGB(255, 225, 225, 225),
  );

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double? fontSize = width <= SheetPage.narrowThreshold ? 32 : null;

    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Chords',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          textTheme: TextTheme(
            displayMedium: TextStyle(fontSize: fontSize),
          ),
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
