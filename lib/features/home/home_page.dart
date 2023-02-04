import 'package:backpack/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'student_home_view.dart';
import 'teacher_home_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    return (user.isTeacher) ? TeacherHomeView(user) : StudentHomeView(user);
  }
}
