import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'student_assignment_buttons.dart';
import 'teacher_assignment_buttons.dart';

class AssignmentDetail extends ConsumerWidget {
  const AssignmentDetail({super.key, required this.assignmentId});

  final String assignmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user info
    final UserProfile user = ref.watch(authProvider).props[0] as UserProfile;

    // Get assignment info
    final Assignment assignment =
        ref.read(assignmentProvider.notifier).getAssignmentFromId(assignmentId);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                Text(
                  assignment.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(),
                if (getDeviceType(MediaQuery.of(context)) == DeviceType.mobile)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(assignmentDetailProvider.notifier).state = null;
                    },
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Text(assignment.instructions),
            ),
            user.isTeacher
                ? TeacherAssignmentButtons(user: user, assignment: assignment)
                : StudentAssignmentButtons(user: user, assignment: assignment),
          ],
        ),
      ),
    );
  }
}
