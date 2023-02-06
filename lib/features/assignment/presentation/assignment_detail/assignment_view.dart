import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'student_assignment_actions.dart';
import 'teacher_assignment_actions.dart';

class AssignmentView extends ConsumerWidget {
  const AssignmentView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTeacher = ref.watch(profileProvider).isTeacher;
    final assignment =
        ref.read(assignmentServiceProvider.notifier).getAssignmentById(id);
    final deviceType = getDeviceType(MediaQuery.of(context));

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  assignment.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                if (deviceType == DeviceType.mobile)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        ref.read(coursePageProvider.notifier).state = null,
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Text(assignment.instructions),
            ),
            (isTeacher)
                ? TeacherAssignmentActions(assignment: assignment)
                : StudentAssignmentActions(assignment: assignment),
          ],
        ),
      ),
    );
  }
}
