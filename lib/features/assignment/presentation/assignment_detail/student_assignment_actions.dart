import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'file_upload.dart';

class StudentAssignmentActions extends ConsumerWidget {
  const StudentAssignmentActions({
    super.key,
    required this.assignment,
  });

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref
        .read(assignmentServiceProvider.notifier)
        .getCompletedAssignmentIds();
    final buttonText =
        assignment.submissionRequired ? 'Submit' : 'Mark as Complete';

    return Column(
      children: <Widget>[
        if (assignment.submissionRequired && !completed.contains(assignment.id))
          const FileUpload(),
        ElevatedButton(
          onPressed: completed.contains(assignment.id)
              ? null
              : () async {
                  await ref
                      .read(assignmentServiceProvider.notifier)
                      .markAssginmentComplete(assignment.id);
                  // Close assignment view
                  ref.read(coursePageProvider.notifier).state = null;
                },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
