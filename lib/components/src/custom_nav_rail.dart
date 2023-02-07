import 'package:flutter/material.dart';

class CustomNavRail extends StatelessWidget {
  const CustomNavRail({
    Key? key,
    required this.navIndex,
    required this.updateTab,
    required this.navIcons,
  }) : super(key: key);

  final int navIndex;
  final Function updateTab;
  final List<Map> navIcons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: NavigationRail(
        selectedIndex: navIndex,
        onDestinationSelected: (index) => updateTab(index),
        labelType: NavigationRailLabelType.all,
        destinations: [
          for (var item in navIcons)
            NavigationRailDestination(
              icon: item['icon'],
              label: Text(item['label']),
            ),
        ],
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
