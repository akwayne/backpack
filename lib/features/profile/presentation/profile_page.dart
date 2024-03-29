import 'package:backpack/components/components.dart';
import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/authentication/authentication.dart';
import 'package:backpack/features/profile/profile.dart';

import 'package:backpack/utilities/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // User info to display
    final UserProfile user = ref.watch(profileProvider);
    final userImage =
        (user.photoUrl != null) ? NetworkImage(user.photoUrl!) : null;

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
            onPressed: () => context.pushNamed(RouteName.profileUpdate),
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
                  image: userImage,
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? '',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 12),
                Text(
                  user.school ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => ref.read(authProvider.notifier).signOut(),
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
