import 'package:flutter/material.dart';

class StaggerItemAnimation extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggerItemAnimation({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(
        milliseconds: 280 + (index * 70),
      ),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (_, value, widget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 22 * (1 - value)),
            child: widget,
          ),
        );
      },
      child: child,
    );
  }
}
