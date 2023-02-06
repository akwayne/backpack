import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          onPressed: () {},
          child: const Text('Add New Assignment'),
        ),
        const SizedBox(height: 12.0),
        AssignmentList(assignmentList),
      ],
    );
  }
}
