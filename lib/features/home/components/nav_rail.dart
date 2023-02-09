import 'package:backpack/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/home_page.dart';

class HomeNavRail extends ConsumerWidget {
  const HomeNavRail({super.key, required this.navPages});

  final List<Map<String, dynamic>> navPages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomNavRail(
      selectedIndex: ref.watch(homeNavIndexProvider),
      onTap: (index) => ref.read(homeNavIndexProvider.notifier).state = index,
      navPages: navPages,
    );
  }
}
