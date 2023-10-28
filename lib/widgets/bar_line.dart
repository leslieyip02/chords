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
        width: 2,
        height: 80,
        color: Colors.black,
      ),
    );
  }
}
