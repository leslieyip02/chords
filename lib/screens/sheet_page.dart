import 'package:chords/models/sheet.dart';
import 'package:chords/widgets/sheet/sheet_container.dart';
import 'package:chords/widgets/sheet/sheet_transposer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SheetPage extends StatefulWidget {
  static const int maxBarsPerRowNarrow = 2;
  static const int maxBarsPerRowWide = 4;
  static const double narrowThreshold = 600;

  const SheetPage({
    super.key,
    this.sheet,
    this.songPath,
  });

  final Sheet? sheet;
  final String? songPath;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  int currentTranspose = 0;
  Sheet? sheet;

  void transposeSheet(int steps) {
    setState(() {
      sheet!.transpose(steps);
      currentTranspose += SheetTransposer.divisions ~/ 2 + steps;
      currentTranspose %= SheetTransposer.divisions;
      currentTranspose -= SheetTransposer.divisions ~/ 2;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.sheet != null) {
      setState(() => sheet = widget.sheet!);
    } else if (widget.songPath != null) {
      rootBundle.loadString(widget.songPath!).then((sheetValue) {
        setState(() => sheet = Sheet.fromString(sheetValue));
      });
    } else {
      throw ArgumentError('SheetPage requires either a sheet or a songPath');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (sheet == null) {
      // placeholder while waiting for sheet to load
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SheetContainer(sheet: sheet as Sheet),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.background,
            leading: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  tooltip: "Back",
                  onPressed: () => Navigator.pop(context),
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.restart_alt),
                tooltip: "Reset",
                onPressed: () => setState(() {
                  // hack to reload the current sheet to resets
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SheetPage(sheet: sheet),
                    ),
                  );
                }),
              ),
              SizedBox(width: 16.0),
              IconButton(
                icon: Icon(Icons.more_vert),
                tooltip: "Transpose",
                onPressed: () => {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SheetTransposer(
                        currentTranspose: currentTranspose,
                        transposeSheet: transposeSheet,
                      );
                    },
                  ),
                },
              ),
              SizedBox(width: 16.0),
            ],
          ),
        );
      },
    );
  }
}
