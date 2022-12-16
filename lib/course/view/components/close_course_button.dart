import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/course_page.dart';

class CloseCourseButton extends ConsumerWidget {
  const CloseCourseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        // Reset tabs and view when closing course page
        ref.read(courseNavIndexProvider.notifier).state = 0;
        ref.read(assignmentDetailProvider.notifier).state = null;

        context.pop();
      },
    );
  }
}
