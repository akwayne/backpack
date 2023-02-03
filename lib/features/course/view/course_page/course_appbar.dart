import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/course.dart';
import 'course_page.dart';

class CourseAppBar extends ConsumerWidget with PreferredSizeWidget {
  const CourseAppBar(this.course, this.assignmentId, {super.key});

  final Course course;
  final String? assignmentId;

  @override
  Size get preferredSize => const Size.fromHeight(65.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(course.name),
      actions: assignmentId == null
          ? [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ref.read(assignmentViewProvider.notifier).state = null;
                  context.pop();
                },
              ),
            ]
          : [],
    );
  }
}
