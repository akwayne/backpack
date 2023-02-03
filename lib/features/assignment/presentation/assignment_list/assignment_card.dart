import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../course/view/old_coursepage.dart';
import 'animated_check.dart';

class AssignmentCard extends ConsumerWidget {
  const AssignmentCard({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get course information for this assignment
    Course course =
        ref.read(courseProvider.notifier).getCourseById(assignment.courseId);

    // User info to display
    final UserProfile user = ref.watch(authProvider).props[0] as UserProfile;

    // checks whether a particular assignment is complete for this user
    final Widget checkbox = user.completed.contains(assignment.id)
        ? const AnimatedCheck()
        : const Icon(
            Icons.circle_outlined,
            size: 38,
          );

    final bool onHomePage =
        ModalRoute.of(context)!.settings.name == RouteName.home;

// Show assignment card
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: checkbox,
        title: Text(
          assignment.name,
          overflow: TextOverflow.ellipsis,
        ),
        // Only show subtitle on home page
        subtitle: onHomePage ? Text(course.name) : null,
        trailing: Image.asset(
          course.subject.image,
          color: const Color.fromRGBO(255, 255, 255, 0.8),
          colorBlendMode: BlendMode.modulate,
        ),
        onTap: () {
          // Change view on course page
          ref.read(assignmentDetailProvider.notifier).state = assignment.id;

          // This checks if we are on the home page or already on course page
          // If we are on the home page, we should navigate to the course page
        },
      ),
    );
  }
}
