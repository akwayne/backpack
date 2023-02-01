import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../assignment/application/assignment_provider.dart';
import '../course/application/course_provider.dart';
import '../auth/domain/user_data.dart';

// Refreshes course and assignment info each time home page is rebuilt
class CloudFutureBuilder extends ConsumerWidget {
  const CloudFutureBuilder({
    super.key,
    required this.user,
    required this.child,
  });

  final UserData user;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      // only try to get data from these providers if a user is logged in
      future: FirebaseAuth.instance.currentUser == null
          ? null
          : Future.wait([
              ref.read(courseProvider.notifier).getCourses(user),
              ref.read(assignmentProvider.notifier).getAssignments(user),
            ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return child;
        }
      },
    );
  }
}
