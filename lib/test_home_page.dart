import 'package:backpack/features/assignment_list/assignment_list.dart';
import 'package:backpack/features/assignment_list/view/assignment_card.dart';

import 'package:backpack/features/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'constants/constants.dart';
import 'features/course_list/course_list.dart';

class TestHomePage extends ConsumerWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    final assignments = ref.watch(assignListProvider);

    return Scaffold(
      appBar: AppBar(
        title: (user.displayName != null) ? Text(user.displayName!) : null,
      ),
      body: ListView(
        children: [
          Text(user.isTeacher ? 'Teacher' : 'Student'),
          ElevatedButton(
            onPressed: () => context.pushNamed(RouteName.profile),
            child: const Text('Profile'),
          ),
          const CourseList(),
          Column(
            children: List.generate(assignments.length,
                (index) => AssignmentCard(assignments[index])),
          ),
        ],
      ),
    );
  }
}
