import 'package:backpack/student/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/student.dart';
import 'student_avatar.dart';

// TODO add delete account
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
                      value: false,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {}),
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
          ],
        ),
      ),
    );
  }
}

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: ProfileScreen(
//         actions: [
//           SignedOutAction(
//               (context) => Navigator.pushReplacementNamed(context, '/login')),
//         ],
//       ),
//     );
//   }
// }
