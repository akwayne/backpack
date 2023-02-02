import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'animated_check.dart';

class AssignmentCard extends ConsumerWidget {
  const AssignmentCard({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get course information for this assignment
    Course course =
        ref.read(courseProvider.notifier).getCourseFromId(assignment.courseId);

    // User info to display
    final UserDetail user = ref.watch(authStateProvider).props[0] as UserDetail;

    // checks whether a particular assignment is complete for this user
    final Widget checkbox = user.completed.contains(assignment.id)
        ? const AnimatedCheck()
        : const Icon(
            Icons.circle_outlined,
            size: 38,
          );

    final bool onHomePage =
        ModalRoute.of(context)!.settings.name == AppRoutes.home;

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
          course.subject.getImage,
          color: const Color.fromRGBO(255, 255, 255, 0.8),
          colorBlendMode: BlendMode.modulate,
        ),
        onTap: () {
          // Change view on course page
          ref.read(assignmentDetailProvider.notifier).state = assignment.id;

          // This checks if we are on the home page or already on course page
          // If we are on the home page, we should navigate to the course page
          if (onHomePage) AppRouter.goCoursePage(context, assignment.courseId);
        },
      ),
    );
  }
}
