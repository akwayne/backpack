import 'package:flutter/material.dart';

import '../course/model/course.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text(course.name),
        subtitle: Text('${course.getTimeString()} / ${course.location}'),
      ),
    );
  }
}
