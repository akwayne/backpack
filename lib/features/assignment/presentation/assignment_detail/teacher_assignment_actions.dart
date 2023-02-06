import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherAssignmentActions extends ConsumerWidget {
  const TeacherAssignmentActions({
    super.key,
    required this.assignment,
  });

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          // TODO edit assignment
          onPressed: () {},
          child: const Text('Edit Assignment'),
        ),
        TextButton(
          onPressed: () async {
            await ref
                .read(assignmentServiceProvider.notifier)
                .deleteAssignment(assignment);
            ref.read(coursePageProvider.notifier).state = null;
          },
          child: const Text(
            'Delete Assignment',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
