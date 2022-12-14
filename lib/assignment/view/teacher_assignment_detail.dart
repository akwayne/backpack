import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../course/view/course_page.dart';
import '../../user/model/app_user.dart';
import '../../user/viewmodel/user_provider.dart';
import '../../utilities/device_type.dart';
import '../model/assignment.dart';
import '../viewmodel/assignment_provider.dart';

class TeacherAssignmentDetail extends ConsumerWidget {
  const TeacherAssignmentDetail({super.key, required this.assignmentId});

  final String assignmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // User info to display
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
            // TODO: Create a way to edit an existing assignment
            // ElevatedButton(
            //   onPressed: () {},
            //   child: Text('Edit Assignment'),
            // ),
            TextButton(
              onPressed: () async {
                // Delete Assignment
                await ref
                    .read(assignmentProvider.notifier)
                    .deleteAssignment(assignment, user);
                // Return to Course View
                ref.read(courseViewProvider.notifier).state = null;
              },
              child: const Text(
                'Delete Assignment',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
