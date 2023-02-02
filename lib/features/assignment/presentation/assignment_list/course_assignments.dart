import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'assignment_card.dart';

class CourseAssignments extends ConsumerWidget {
  const CourseAssignments({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // rebuild when an assignment changes
    ref.watch(assignmentProvider);

    final courseAssignments =
        ref.read(assignmentProvider.notifier).getCourseAssignments(course.id);

    return ListView(
      children: <Widget>[
        ElevatedButton(
            onPressed: () => AppRouter.goAddAssignment(context, course.id),
            child: const Text('Add New Assignment')),
        const SizedBox(height: 14),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          itemCount: courseAssignments.length,
          itemBuilder: ((context, index) =>
              AssignmentCard(assignment: courseAssignments[index])),
        ),
      ],
    );
  }
}
