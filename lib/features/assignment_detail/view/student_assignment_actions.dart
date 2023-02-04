import 'package:backpack/features/course_detail/course_detail.dart';
import 'package:backpack/features/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/src/assignment.dart';
import 'file_upload.dart';

class StudentAssignmentActions extends ConsumerWidget {
  const StudentAssignmentActions({
    super.key,
    required this.user,
    required this.assignment,
  });

  final UserProfile user;
  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonText =
        assignment.submissionRequired ? 'Submit' : 'Mark as Complete';
    return Column(
      children: <Widget>[
        if (assignment.submissionRequired &&
            !user.completed.contains(assignment.id))
          const FileUpload(),
        ElevatedButton(
          onPressed: user.completed.contains(assignment.id)
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
