import 'package:flutter/material.dart';
import 'package:chords/widgets/sheet_selector.dart';

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
          child: SheetSelector(),
        ),
      );
    });
  }
}
