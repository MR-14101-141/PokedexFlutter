import 'package:flutter/material.dart';

class SizeAnimation extends StatefulWidget {
  final double delay;
  final Widget child;

  const SizeAnimation({Key? key, required this.delay, required this.child})
      : super(key: key);

  @override
  _SizeTransitionDemoState createState() => _SizeTransitionDemoState();
}

class _SizeTransitionDemoState extends State<SizeAnimation>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();

    animationController = AnimationController(
      duration: Duration(milliseconds: (500 * widget.delay).round()),
      vsync: this,
    )..forward();
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        axisAlignment: 2,
        child: widget.child);
  }
}
