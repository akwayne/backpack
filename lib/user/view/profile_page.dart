import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utilities/utilities.dart';
import '../model/student.dart';
import '../viewmodel/student_provider.dart';
import 'student_avatar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Student info to display
    final student = ref.watch(studentProvider) ?? Student.empty();

    // get device details
    bool isMobile = getDeviceType(MediaQuery.of(context)) == DeviceType.mobile;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

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
        child: Padding(
          padding: (isMobile && isLandscape)
              ? const EdgeInsets.all(8.0)
              : const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: [
                StudentAvatar(
                  imageRadius: 60,
                  image: NetworkImage(student.imageURL),
                ),
                const SizedBox(height: 16),
                Text(
                  '${student.firstName} ${student.lastName}',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 12),
                Text(
                  student.school,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // pop back to home screen
                    context.goNamed('login');
                    ref.read(studentProvider.notifier).logOut();
                  },
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
