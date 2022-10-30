import 'package:backpack/student/view/profile_update.dart';
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
    final student = ref.watch(studentProvider) ?? Student.empty();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileUpdate(student: student),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
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
              // I can not make this switch work
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Text('Dark Mode'),
              //       Switch(
              //         value: student.isDarkMode,
              //         activeColor: Theme.of(context).colorScheme.primary,
              //         onChanged: (value) async {
              //           await ref.read(studentProvider.notifier).toggleTheme();
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              TextButton(
                onPressed: () {
                  Navigator.restorablePushNamedAndRemoveUntil(
                      context, '/login', (Route<dynamic> route) => false);
                  ref.read(studentProvider.notifier).logOut();
                },
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
