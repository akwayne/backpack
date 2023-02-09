import 'package:backpack/features/course/course.dart';
import 'package:flutter/material.dart';

import 'course_close_button.dart';

class CourseAppBar extends StatelessWidget with PreferredSizeWidget {
  const CourseAppBar(this.course, this.assignmentId, {super.key});

  final Course course;
  final String? assignmentId;

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(course.name),
      actions: assignmentId == null ? [const CourseCloseButton()] : [],
    );
  }
}
