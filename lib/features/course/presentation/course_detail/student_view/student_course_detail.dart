import 'package:backpack/features/assignment/assignment.dart';
import 'package:backpack/features/course/course.dart';
import 'package:flutter/material.dart';

class StudentCourseDetail extends StatelessWidget {
  const StudentCourseDetail(this.course, this.assignments, {super.key});

  final Course course;
  final List<Assignment> assignments;

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
        ),
        AssignmentList(assignments),
      ],
    );
  }
}