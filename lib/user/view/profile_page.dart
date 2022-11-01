import 'package:backpack/user/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed('profileUpdate');
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StudentAvatar(
                  imageRadius: 60,
                  image: NetworkImage(student.imageURL),
                ),
              ),
              Text(
                '${student.firstName} ${student.lastName}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                student.school,
                style: Theme.of(context).textTheme.headline6,
              ),
              // TODO I can not make this switch work
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
                  context.goNamed('login');
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
