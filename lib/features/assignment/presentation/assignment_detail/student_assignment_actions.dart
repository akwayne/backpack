import 'dart:io';

import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentAssignmentActions extends ConsumerStatefulWidget {
  const StudentAssignmentActions({super.key, required this.assignment});

  final Assignment assignment;

  @override
  StudentAssignmentActionsState createState() =>
      StudentAssignmentActionsState();
}

class StudentAssignmentActionsState
    extends ConsumerState<StudentAssignmentActions> {
  @override
  Widget build(BuildContext context) {
    FilePickerResult? result;
    File? file;

    final isCompleted = (ref
            .read(assignmentServiceProvider.notifier)
            .getCompletedAssignmentIds())
        .contains(widget.assignment.id);
    final buttonText =
        widget.assignment.submissionRequired ? 'Submit' : 'Mark as Complete';

    return Column(
      children: <Widget>[
        if (widget.assignment.submissionRequired && !isCompleted)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              children: [
                if (result != null) Text('File: ${result.files.single.name}'),
                TextButton(
                  onPressed: () async {
                    // For now, only supports upload of a single file.
                    result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      file = File(result!.files.single.path!);
                      setState(() {});
                    }
                  },
                  child: const Text('Upload a File'),
                ),
              ],
            ),
          ),
        ElevatedButton(
          onPressed: isCompleted
              ? null
              : () async {
                  await ref
                      .read(assignmentServiceProvider.notifier)
                      .submitAssignment(widget.assignment, file);
                  // Close assignment view
                  ref.read(courseSubViewProvider.notifier).state = null;
                },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
