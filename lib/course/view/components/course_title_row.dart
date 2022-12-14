import 'package:flutter/material.dart';

import '../../model/course.dart';
import 'course_components.dart';

class CourseTitleRow extends StatelessWidget {
  const CourseTitleRow({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          course.name,
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const CloseCourseButton(),
      ],
    );
  }
}
