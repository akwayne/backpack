import 'package:backpack/models/models.dart';
import 'package:flutter/material.dart';

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
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
      ],
    );
  }
}
