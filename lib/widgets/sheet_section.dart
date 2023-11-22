import 'package:chords/widgets/sheet_row.dart';
import 'package:flutter/material.dart';
import 'package:chords/models/chord.dart';
import 'package:chords/models/section.dart';
import 'package:chords/screens/sheet_page.dart';

class SheetSection extends StatelessWidget {
  const SheetSection({
    super.key,
    required this.section,
  });

  final Section section;

  /// assign either 1, 2 or 4 bars per row
  List<List<List<Chord>>> distributeRows() {
    // TODO: refactor spaghetti
    List<List<List<Chord>>> rows = [];
    List<List<Chord>> currentRow = [];
    bool containsLongBar = false;
    for (var bar in section.bars) {
      // if the bar contains >= 3 chords,
      // spread bars out to prevent cramming
      containsLongBar = containsLongBar || bar.length >= 3;
      if (containsLongBar && currentRow.isNotEmpty) {
        if (currentRow.length == 1) {
          currentRow.add(bar);
          rows.add(currentRow.sublist(0));
          currentRow.clear();
          containsLongBar = false;
        } else if (currentRow.length == 2) {
          rows.add(currentRow.sublist(0));
          currentRow.clear();
          currentRow.add(bar);
        } else if (currentRow.length == 3) {
          List<Chord> previous = currentRow.removeLast();
          rows.add(currentRow.sublist(0));
          rows.add([previous, bar]);
          currentRow.clear();
          containsLongBar = false;
        }
      } else {
        currentRow.add(bar);
        if (currentRow.length == SheetPage.maxBarsPerRow) {
          rows.add(currentRow.sublist(0));
          currentRow.clear();
        }
      }
    }
    if (currentRow.isNotEmpty) {
      // split rows with a length of 3
      if (currentRow.length == 3) {
        List<Chord> last = currentRow.removeLast();
        rows.add(currentRow.sublist(0));
        rows.add([last]);
      } else {
        rows.add(currentRow);
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<List<List<Chord>>> rows = distributeRows();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.label != null)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                section.label as String,
                style: TextStyle(color: theme.colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: 4.0),
          for (var row in rows) SheetRow(bars: row),
        ],
      ),
    );
  }
}
