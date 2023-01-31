import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/domain/app_user.dart';
import '../../../features/auth/application/auth_provider.dart';
import '../../../features/course/course.dart';
import '../../../utilities/utilities.dart';
import '../../model/assignment.dart';
import '../../viewmodel/assignment_provider.dart';
import '../components/assignment_components.dart';

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
