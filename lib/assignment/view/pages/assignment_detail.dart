import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../course/view/pages/course_page.dart';
import '../../../user/model/app_user.dart';
import '../../../user/viewmodel/user_provider.dart';
import '../../../utilities/utilities.dart';
import '../../model/assignment.dart';
import '../../viewmodel/assignment_provider.dart';
import '../components/file_upload.dart';

class AssignmentDetail extends ConsumerWidget {
  const AssignmentDetail({super.key, required this.assignmentId});

  final String assignmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user info
    final AppUser user = ref.watch(userProvider) ?? AppUser.empty();

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
                    onPressed: () => ref
                        .read(assignmentDetailProvider.notifier)
                        .state = null,
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Text(assignment.instructions),
            ),
            user.isTeacher
                ? _TeacherComponents(user: user, assignment: assignment)
                : _StudentComponents(user: user, assignment: assignment),
          ],
        ),
      ),
    );
  }
}

class _TeacherComponents extends ConsumerWidget {
  const _TeacherComponents({
    required this.user,
    required this.assignment,
  });

  final AppUser user;
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

class _StudentComponents extends ConsumerWidget {
  const _StudentComponents({
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
