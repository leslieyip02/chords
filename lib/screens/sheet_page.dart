import 'package:chords/widgets/sheet_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:chords/models/sheet.dart';
import 'package:chords/providers/app_state.dart';

class SheetPage extends StatelessWidget {
  static const int maxBarsPerRow = 4;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var song = appState.song;
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge;

    return FutureBuilder<String>(
      future: rootBundle.loadString('assets/sheets/$song'),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return Text('woops');
        }

        Sheet sheet = Sheet.fromString(snapshot.data as String);
        List<Widget> sections = sheet.sections
            .map((section) => SheetSection(section: section))
            .toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: double.infinity,
              margin: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // title
                    Text(
                      sheet.title,
                      style: style,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          sheet.composer,
                        ),
                      ],
                    ),
                    ...sections,
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
