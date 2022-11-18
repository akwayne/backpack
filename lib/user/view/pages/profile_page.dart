import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/utilities.dart';
import '../../model/app_user.dart';
import '../../viewmodel/user_provider.dart';
import '../components/user_avatar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // User info to display
    final user = ref.watch(userProvider) ?? AppUser.empty();

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
                UserAvatar(
                  imageRadius: 60,
                  image: NetworkImage(user.imageURL),
                ),
                const SizedBox(height: 16),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 12),
                Text(
                  user.school,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // pop back to home screen
                    context.goNamed('login');
                    ref.read(userProvider.notifier).logOut();
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
