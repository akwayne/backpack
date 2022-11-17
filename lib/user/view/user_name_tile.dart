import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/app_user.dart';
import 'user_avatar.dart';

class UserNameTile extends StatelessWidget {
  const UserNameTile({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('profile');
      },
      child: Row(
        children: [
          UserAvatar(
            imageRadius: 30,
            image: NetworkImage(user.imageURL),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.firstName} ${user.lastName}',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(user.school, style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
