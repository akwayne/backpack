import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'course_sub_view_provider.dart';

class CourseCloseButton extends ConsumerWidget {
  const CourseCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        ref.read(courseSubViewProvider.notifier).state = null;
        context.pop();
      },
    );
  }
}
