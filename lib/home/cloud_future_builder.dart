import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../assignment/viewmodel/assignment_provider.dart';
import '../course/viewmodel/course_provider.dart';

// Refreshes course and assignment info each time home page is rebuilt
class CloudFutureBuilder extends ConsumerWidget {
  const CloudFutureBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait([
        ref.read(courseProvider.notifier).getCourses(),
        ref.read(assignmentProvider.notifier).getAssignments(),
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
