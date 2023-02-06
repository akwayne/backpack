import 'package:backpack/features/course_detail/course_detail.dart';
import 'package:backpack/models/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/assignment_service.dart';
import 'file_upload.dart';

class StudentAssignmentActions extends ConsumerWidget {
  const StudentAssignmentActions({
    super.key,
    required this.assignment,
  });

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed =
        ref.watch(assignmentServiceProvider).getCompletedAssignmentIds();
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
                  // TODO Change assignment status to complete

                  // Close assignment view
                  ref.read(courseViewProvider.notifier).state = null;
                },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
