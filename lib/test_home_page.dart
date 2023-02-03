import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'constants/constants.dart';

class TestHomePage extends ConsumerWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: (user.displayName != null) ? Text(user.displayName!) : null,
      ),
      body: FutureBuilder(
          future: ref.read(courseProvider.notifier).getCourses(),
          builder: (context, snapshot) {
            final courses = ref.watch(courseProvider);
            return ListView(
              children: [
                Text(user.isTeacher ? 'Teacher' : 'Student'),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(RouteName.profile);
                  },
                  child: const Text('Profile'),
                ),
                Column(
                  children: [for (Course course in courses) Text(course.name)],
                )
              ],
            );
          }),
    );
  }
}
