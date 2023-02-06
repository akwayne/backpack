import 'package:backpack/features/course_detail/course_detail.dart';
import 'package:backpack/models/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherAssignmentActions extends ConsumerWidget {
  const TeacherAssignmentActions({
    super.key,
    required this.assignment,
  });

  final Assignment assignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          // TODO edit assignment
          onPressed: () {},
          child: const Text('Edit Assignment'),
        ),
        TextButton(
          onPressed: () async {
            // Delete Assignment
            // Close assignment view
            ref.read(courseViewProvider.notifier).state = null;
          },
          child: const Text(
            'Delete Assignment',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
