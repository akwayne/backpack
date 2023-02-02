import 'package:backpack/features/profile/application/user_provider.dart';
import 'package:backpack/features/authorization/authorization.dart';
import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestHomePage extends ConsumerWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: (user.displayName != null) ? Text(user.displayName!) : null,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).signOut();
              AppRouter.goLogin(context);
            },
            child: const Text('Sign Out'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).deleteUser();
              AppRouter.goLogin(context);
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
