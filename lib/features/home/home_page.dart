import 'package:backpack/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use different navigation pages for students and teachers
    final user = ref.watch(profileProvider);

    return (user.isTeacher)
        ? HomeView(user: user, navPages: _teacherNavPages)
        : HomeView(user: user, navPages: _studentNavPages);
  }
}

final _studentNavPages = <Map<String, dynamic>>[
  {
    'page': Container(),
    'icon': const Icon(Icons.check_circle_outline),
    'label': 'home',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.class_),
    'label': 'my classes',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.calendar_today),
    'label': 'schedule',
  },
];

final _teacherNavPages = <Map<String, dynamic>>[
  {
    'page': Container(),
    'icon': const Icon(Icons.check_circle_outline),
    'label': 'home',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.class_),
    'label': 'my classes',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.calendar_today),
    'label': 'schedule',
  },
];
