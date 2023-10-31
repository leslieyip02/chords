import 'package:chords/screens/sheet_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            child: ButtonBar(
              mainAxisSize: MainAxisSize.min,
              buttonPadding: EdgeInsets.all(8.0),
              children: [Text('To Sheet'), Icon(Icons.search)],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SheetPage()),
              );
            },
          ),
        ),
      );
    });
  }
}
