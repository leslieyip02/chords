import 'dart:math';
import 'package:flutter/material.dart';

class ShakeableContainer extends StatefulWidget {
  const ShakeableContainer({
    super.key,
    required this.child,
    this.shakeCount = 3,
    this.shakeOffset = 8.0,
    this.shakeDuration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final int shakeCount;
  final double shakeOffset;
  final Duration shakeDuration;

  @override
  State<ShakeableContainer> createState() => ShakeableContainerState();
}

class ShakeableContainerState extends State<ShakeableContainer>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.shakeDuration,
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: SineCurve(count: widget.shakeCount),
    ));
    controller.addStatusListener(updateAnimationStatus);
  }

  @override
  void dispose() {
    controller.removeStatusListener(updateAnimationStatus);
    super.dispose();
  }

  void shake() {
    controller.forward();
  }

  void updateAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.reset();
    }
  }

  @override
  Widget build(context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animation.value * widget.shakeOffset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class SineCurve extends Curve {
  const SineCurve({
    this.count = 3,
  });

  final int count;

  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}
