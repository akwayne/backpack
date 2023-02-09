import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Check box displays animated check if complete
class AssignmentCheckBox extends ConsumerWidget {
  const AssignmentCheckBox(this.assignmentId, {super.key});

  final String assignmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(profileProvider).completed.contains(assignmentId)
        ? const _AnimatedCheck()
        : const Icon(
            Icons.circle_outlined,
            size: 38,
          );
  }
}

class _AnimatedCheck extends StatefulWidget {
  const _AnimatedCheck();

  @override
  State<_AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<_AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> shrink;
  late Animation<double> grow;
  late Animation<Color?> color;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    // Animations defined here
    shrink = Tween<double>(begin: 38.0, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeInBack),
      ),
    )..addListener(() => setState(() {}));

    grow = Tween<double>(begin: 0.0, end: 38.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    )..addListener(() => setState(() {}));

    color = ColorTween(
      begin: AppColors.text,
      end: AppColors.darkPrimary,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.8, curve: Curves.ease),
      ),
    )..addListener(() => setState(() {}));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      width: 38,
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
  }
}
