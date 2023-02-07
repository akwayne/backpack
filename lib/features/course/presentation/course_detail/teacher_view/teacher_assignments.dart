import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TeacherCourseAssignments extends ConsumerWidget {
  const TeacherCourseAssignments(this.course, {super.key});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentList = ref
        .read(assignmentServiceProvider.notifier)
        .getAssignmentsForCourse(course.id);

    return ListView(
      children: [
        ElevatedButton(
          onPressed: () => context.pushNamed(
            RouteName.addAssignment,
            params: {'id': course.id},
          ),
          child: const Text('Add New Assignment'),
        ),
        const SizedBox(height: 12.0),
        AssignmentList(assignmentList),
      ],
    );
  }
}
