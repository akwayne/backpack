import 'package:flutter/material.dart';

class CustomFadeTransition extends StatelessWidget {
  const CustomFadeTransition({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeIn,
      child: child,
    );
  }
}
