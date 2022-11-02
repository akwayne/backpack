import 'package:backpack/assignment/view/file_upload.dart';
import 'package:backpack/utilities/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../course/view/course_page.dart';
import '../../user/model/student.dart';
import '../../user/viewmodel/student_provider.dart';
import '../model/assignment.dart';
import '../viewmodel/assignment_provider.dart';

class AssignmentDetail extends ConsumerWidget {
  const AssignmentDetail({super.key, required this.assignmentId});

  final String assignmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Student info to display
    final Student student = ref.watch(studentProvider) ?? Student.empty();

    // Get assignment info
    final Assignment assignment =
        ref.read(assignmentProvider.notifier).getAssignmentFromId(assignmentId);

    // Text to display on submit button
    final buttonText =
        assignment.submissionRequired ? 'Submit' : 'Mark as Complete';

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
                    onPressed: () =>
                        ref.read(courseViewProvider.notifier).state = null,
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Text(assignment.instructions),
            ),

            // Show upload section if assignment requries a file upload
            // And not already submitted
            if (assignment.submissionRequired &&
                !student.completed.contains(assignment.id))
              const FileUpload(),

            // Disable button if assignment is already submitted
            ElevatedButton(
              onPressed: student.completed.contains(assignment.id)
                  ? null
                  : () async {
                      // Change assignment status to complete
                      ref
                          .read(studentProvider.notifier)
                          .markComplete(assignment.id);
                      // Return to course page
                      ref.read(courseViewProvider.notifier).state = null;
                    },
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
