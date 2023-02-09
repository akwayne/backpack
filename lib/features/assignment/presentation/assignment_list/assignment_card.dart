import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/assignment/assignment.dart';

import 'package:backpack/features/course/course.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'checkbox.dart';

class AssignmentCard extends ConsumerWidget {
  const AssignmentCard(this.assignment, {super.key});

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onHomePage = ModalRoute.of(context)!.settings.name == RouteName.home;
    final course = ref
        .read(courseServiceProvider.notifier)
        .getCourseById(assignment.courseId);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: AssignmentCheckBox(assignment.id),
        title: Text(
          assignment.name,
          overflow: TextOverflow.ellipsis,
        ),
        // Only show course name on the home page
        subtitle: onHomePage ? Text(course.name) : null,
        trailing: Image.asset(
          course.subject.image,
          color: const Color.fromRGBO(255, 255, 255, 0.8),
          colorBlendMode: BlendMode.modulate,
        ),
        onTap: () {
          // Change the assignment view on the course page
          ref.read(courseSubViewProvider.notifier).state = assignment.id;

          // If we are on the home page, we should navigate to the course page
          if (onHomePage) {
            context.pushNamed(
              RouteName.course,
              params: {'id': assignment.courseId},
            );
          }
        },
      ),
    );
  }
}
