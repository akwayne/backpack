import 'package:backpack/models/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../viewmodel/course_view_provider.dart';

class CourseAppBar extends ConsumerWidget with PreferredSizeWidget {
  const CourseAppBar(this.course, this.assignmentId, {super.key});

  final Course course;
  final String? assignmentId;

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

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
                  ref.read(courseViewProvider.notifier).state = null;
                  context.pop();
                },
              ),
            ]
          : [],
    );
  }
}
