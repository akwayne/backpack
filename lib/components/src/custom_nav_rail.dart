import 'package:flutter/material.dart';

class CustomNavRail extends StatelessWidget {
  const CustomNavRail({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.navPages,
  }) : super(key: key);

  final int selectedIndex;
  final Function onTap;
  final List<Map<String, dynamic>> navPages;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => onTap(index),
        labelType: NavigationRailLabelType.all,
        destinations: List.generate(
          navPages.length,
          (index) => NavigationRailDestination(
            icon: navPages[index]['icon'],
            label: Text(navPages[index]['label']),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
