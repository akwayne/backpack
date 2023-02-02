import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/routing/routing.dart';
import 'package:flutter/material.dart';

import 'user_avatar.dart';

class UserNameTile extends StatelessWidget {
  const UserNameTile({super.key, required this.user});

  final UserDetail user;

  @override
  Widget build(BuildContext context) {
    final userImage =
        user.photoUrl != null ? NetworkImage(user.photoUrl!) : null;

    return GestureDetector(
      onTap: () => AppRouter.goProfile(context),
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
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(user.school ?? '',
                  style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
