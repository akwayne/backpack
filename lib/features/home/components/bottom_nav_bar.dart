import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/home_page.dart';

class HomeBottomNavBar extends ConsumerWidget {
  const HomeBottomNavBar({super.key, required this.navPages});

  final List<Map<String, dynamic>> navPages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: ref.watch(homeNavIndexProvider),
      onTap: (index) => ref.read(homeNavIndexProvider.notifier).state = index,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      items: List.generate(
        navPages.length,
        (index) => BottomNavigationBarItem(
          icon: navPages[index]['icon'],
          label: navPages[index]['label'],
        ),
      ),
    );
  }
}
