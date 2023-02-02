import 'package:backpack/features/profile/viewmodel/profile_provider.dart';
import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestHomePage extends ConsumerWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: (user.displayName != null) ? Text(user.displayName!) : null,
      ),
      body: Column(
        children: [
          Text(user.isTeacher ? 'Teacher' : 'Student'),
          ElevatedButton(
            onPressed: () {
              AppRouter.goProfile(context);
            },
            child: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
