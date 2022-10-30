import 'package:backpack/student/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/student.dart';
import 'student_avatar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Student info to display
    final Student student = ref.watch(studentProvider) ?? Student.empty();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/profileupdate'),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: StudentAvatar(imageRadius: 60),
            ),
            Text(
              '${student.firstName} ${student.lastName}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              student.school,
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Dark Mode'),
                  Switch(
                    value: student.isDarkMode,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) async {
                      await ref.read(studentProvider.notifier).toggleTheme();
                    },
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(studentProvider.notifier).logOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Log Out'),
            ),
            TextButton(
              onPressed: () {
                // ref.read(studentProvider.notifier).deleteUser();
                // Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
