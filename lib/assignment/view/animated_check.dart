import 'package:flutter/material.dart';

import '../../utilities/utilities.dart';

class AnimatedCheck extends StatefulWidget {
  const AnimatedCheck({super.key});

  @override
  State<AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return CheckAnim(controller: _controller.view);
  }
}

class CheckAnim extends StatelessWidget {
  CheckAnim({super.key, required this.controller})
      : shrink = Tween<double>(
          begin: 38.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.2,
              curve: Curves.easeInBack,
            ),
          ),
        ),
        grow = Tween<double>(
          begin: 0.0,
          end: 38.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.2,
              1.0,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        color = ColorTween(
          begin: ColorPalette.text,
          end: ColorPalette.darkPrimary,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.2,
              0.8,
              curve: Curves.ease,
            ),
          ),
        );

  final Animation<double> controller;
  final Animation<double> shrink;
  final Animation<double> grow;
  final Animation<Color?> color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          width: 38,
          height: 38,
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.circle_outlined,
                  size: shrink.value,
                ),
              ),
              Center(
                child: Icon(
                  Icons.check_circle,
                  size: grow.value,
                  color: color.value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
