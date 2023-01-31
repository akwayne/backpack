import 'package:backpack/features/course/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../assignment/view/components/assignment_card.dart';
import '../../assignment/viewmodel/assignment_provider.dart';

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

    final courseAssignments = ref
        .read(assignmentProvider.notifier)
        .getCourseAssignments(course.courseId);

    return ListView(
      children: <Widget>[
        ElevatedButton(
            onPressed: () => context.pushNamed(
                  'addAssignment',
                  params: {'courseId': course.courseId},
                ),
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
