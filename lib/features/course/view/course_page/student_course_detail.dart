import 'package:flutter/material.dart';

import '../../model/course.dart';

class StudentCourseDetail extends StatelessWidget {
  const StudentCourseDetail(this.course, {super.key});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Text(
          course.teacherName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Wrap(
          children: [
            Chip(label: Text(course.getWeekdayString)),
            Chip(label: Text(course.getTimeString)),
            Chip(label: Text(course.location)),
          ],
        )
        // TODO Assignment List Here
      ],
    );
  }
}
