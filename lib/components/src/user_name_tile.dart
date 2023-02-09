import 'package:backpack/constants/constants.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'user_avatar.dart';

class UserNameTile extends StatelessWidget {
  const UserNameTile({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final userImage =
        user.photoUrl != null ? NetworkImage(user.photoUrl!) : null;

    return GestureDetector(
      onTap: () => context.pushNamed(RouteName.profile),
      child: Row(
        children: [
          UserAvatar(
            imageRadius: 30,
            image: userImage,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName ?? '',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(user.school ?? '',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
