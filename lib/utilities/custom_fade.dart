import 'package:flutter/material.dart';

class CustomFade extends StatelessWidget {
  const CustomFade({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeIn,
      child: child,
    );
  }
}
