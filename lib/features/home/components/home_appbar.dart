import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends ConsumerWidget with PreferredSizeWidget {
  const HomeAppBar({super.key, required this.user});

  final UserProfile user;

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AppBar(
        automaticallyImplyLeading:
            (orientation == Orientation.landscape) ? true : false,
        centerTitle: false,
        title: Text(user.displayName ?? ''),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.pushNamed(RouteName.profile),
              icon: const Icon(
                Icons.account_circle,
                size: 30,
              )),
        ],
      ),
    );
  }
}
