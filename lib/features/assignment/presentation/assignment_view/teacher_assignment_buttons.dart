import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/user_data.dart';
import '../../../course/presentation/course_view/course_page.dart';
import '../../domain/assignment.dart';
import '../../application/assignment_provider.dart';

class TeacherAssignmentButtons extends ConsumerWidget {
  const TeacherAssignmentButtons({
    super.key,
    required this.user,
    required this.assignment,
  });

  final UserData user;
  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Create a way to edit an existing assignment
    return TextButton(
      onPressed: () async {
        // Delete Assignment
        await ref
            .read(assignmentProvider.notifier)
            .deleteAssignment(assignment, user);
        // Return to Course View
        ref.read(assignmentDetailProvider.notifier).state = null;
      },
      child: const Text(
        'Delete Assignment',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
