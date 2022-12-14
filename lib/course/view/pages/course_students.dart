import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user/view/components/user_avatar.dart';
import '../../model/course.dart';

class CourseStudents extends ConsumerWidget {
  const CourseStudents({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: <Widget>[
        // TODO Update with student data
        ListTile(
          leading: UserAvatar(
            imageRadius: 24,
            image: null,
          ),
          title: Text('Student Name'),
          trailing: Text('85%'),
          onTap: () {
            // Go to student view ??
          },
        )
      ],
    );
  }
}
