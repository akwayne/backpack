import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'home_nav_provider.dart';

class HomeNavDrawer extends ConsumerWidget {
  const HomeNavDrawer({super.key, required this.navPages});

  final List<Map<String, dynamic>> navPages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: List.generate(
          navPages.length,
          (index) => ListTile(
            leading: navPages[index]['icon'],
            title: Text(navPages[index]['label']),
            onTap: () {
              ref.read(homeNavIndexProvider.notifier).state = index;
              context.pop();
            },
          ),
        ),
      ),
    );
  }
}
