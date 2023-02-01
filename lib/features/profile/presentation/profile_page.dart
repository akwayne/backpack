import 'package:backpack/components/components.dart';
import 'package:backpack/features/auth/auth.dart';
import 'package:backpack/routing/routing.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // User info to display
    final user = ref.watch(authProvider) ?? UserData.empty();
    final userImage = user.imageURL != '' ? NetworkImage(user.imageURL) : null;

    // get device details
    bool isMobile = getDeviceType(MediaQuery.of(context)) == DeviceType.mobile;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => AppRouter.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () => AppRouter.goProfileUpdate(context),
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
                    AppRouter.goLogin(context);
                    ref.read(authProvider.notifier).logOut();
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
