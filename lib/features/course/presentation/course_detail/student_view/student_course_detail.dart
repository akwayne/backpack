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
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            course.teacherName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Wrap(
          spacing: 10.0,
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
