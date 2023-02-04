import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_nav_provider.dart';

class HomeNavRail extends ConsumerWidget {
  const HomeNavRail({super.key, required this.navPages});

  final List<Map<String, dynamic>> navPages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
