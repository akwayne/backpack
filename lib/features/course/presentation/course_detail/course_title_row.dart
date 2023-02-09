import 'package:backpack/features/course/course.dart';
import 'package:flutter/material.dart';

import 'course_close_button.dart';

class CourseTitleRow extends StatelessWidget {
  const CourseTitleRow({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40.0),
        Text(
          course.name,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const CourseCloseButton(),
      ],
    );
  }
}
