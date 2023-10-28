import 'package:flutter/material.dart';

class BarLine extends StatelessWidget {
  const BarLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Container(
        width: 2.0,
        height: 80.0,
        margin: EdgeInsets.only(
          left: 4.0,
          right: 4.0,
        ),
        color: Colors.black,
      ),
    );
  }
}
