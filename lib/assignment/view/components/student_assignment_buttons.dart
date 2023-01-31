import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/domain/app_user.dart';
import '../../../features/auth/application/auth_provider.dart';
import '../../../features/course/course.dart';
import '../../model/assignment.dart';
import 'assignment_components.dart';

class StudentAssignmentButtons extends ConsumerWidget {
  const StudentAssignmentButtons({
    super.key,
    required this.user,
    required this.assignment,
  });

  final AppUser user;
  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Text to display on submit button
    final buttonText =
        assignment.submissionRequired ? 'Submit' : 'Mark as Complete';
    return Column(
      children: <Widget>[
        // Show upload section if assignment requries a file upload
        // And not already submitted
        if (assignment.submissionRequired &&
            !user.completed.contains(assignment.id))
          const FileUpload(),
        // Disable button if assignment is already submitted
        ElevatedButton(
          onPressed: user.completed.contains(assignment.id)
              ? null
              : () async {
                  // Change assignment status to complete
                  ref.read(userProvider.notifier).markComplete(assignment.id);
                  // Return to course page
                  ref.read(assignmentDetailProvider.notifier).state = null;
                },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
