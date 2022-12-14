import 'package:backpack/calendar/calendar_page.dart';
import 'package:backpack/user/view/components/user_name_tile.dart';
import 'package:backpack/user/viewmodel/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../assignment/view/assignment_list.dart';
import '../course/view/course_list.dart';
import '../user/model/app_user.dart';
import '../utilities/utilities.dart';
import 'cloud_future_builder.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);

class HomeNavigation extends ConsumerWidget {
  const HomeNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Nav Index from Provider
    final navIndex = ref.watch(navIndexProvider);

    // Function to update selected index when an icon is clicked on
    void updateNavTab(int newIndex) {
      ref.read(navIndexProvider.notifier).state = newIndex;
    }

    // User info to display
    final user = ref.watch(userProvider) ?? AppUser.empty();

    // Nav icon list
    final navIcons = user.isTeacher ? _teacherNavIcons : _studentNavIcons;

    return LayoutBuilder(
      builder: (context, constraints) {
        return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
            ? _buildMobileView(
                context,
                navIndex,
                navIcons,
                user,
                updateNavTab,
              )
            : _buildTabletView(
                context,
                navIndex,
                navIcons,
                user,
                updateNavTab,
              );
      },
    );
  }
}

Widget _buildMobileView(
  BuildContext context,
  int navIndex,
  List<Map<String, dynamic>> navIcons,
  AppUser user,
  Function updateNavTab,
) {
  // Determine if phone is in portrait or landscape mode
  bool isLandscape =
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Populate list of Navigation Bar Icons
  final bottomNavItems = <BottomNavigationBarItem>[];
  for (var item in navIcons) {
    bottomNavItems.add(BottomNavigationBarItem(
      icon: item['icon'],
      label: item['label'],
    ));
  }

  return Scaffold(
    appBar: AppBar(
      // Hide leading in portrait mode
      automaticallyImplyLeading: isLandscape ? true : false,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(user.firstName),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            onPressed: () {
              context.pushNamed('profile');
            },
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
          ),
        ),
      ],
    ),

    // Drawer only for landscape mode
    drawer: isLandscape
        ? Drawer(
            child: ListView.builder(
              itemCount: navIcons.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  leading: navIcons[index]['icon'],
                  title: Text(navIcons[index]['label']),
                  onTap: () {
                    updateNavTab(index);
                    Navigator.pop(context);
                  },
                );
              }),
            ),
          )
        : null,

    // Bottom nav bar only for portrait mode
    bottomNavigationBar: !isLandscape
        ? BottomNavigationBar(
            currentIndex: navIndex,
            onTap: (index) => updateNavTab(index),
            items: bottomNavItems,
            selectedItemColor: Theme.of(context).colorScheme.primary,
          )
        : null,

    // Selected item fills rest of page
    body: SafeArea(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildNavPage(navIndex, user)),
    ),
  );
}

Widget _buildTabletView(
  BuildContext context,
  int navIndex,
  List<Map<String, dynamic>> navIcons,
  AppUser user,
  Function updateNavTab,
) {
  // Populate list of Navigation Bar Icons
  final navRailItems = <NavigationRailDestination>[];
  for (var item in navIcons) {
    navRailItems.add(NavigationRailDestination(
        icon: item['icon'], label: Text(item['label'])));
  }

  return Scaffold(
    body: Row(
      children: <Widget>[
        Container(
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
            onDestinationSelected: (index) => updateNavTab(index),
            labelType: NavigationRailLabelType.all,
            destinations: navRailItems,
            backgroundColor: Colors.transparent,
          ),
        ),

        // Selected page is displayed to the right of the nav rail
        Expanded(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  UserNameTile(user: user),
                  const SizedBox(height: 28),
                  Expanded(
                    child: _buildNavPage(navIndex, user),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildNavPage(int navIndex, AppUser user) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: CloudFutureBuilder(
      key: ValueKey(navIndex),
      user: user,
      child: user.isTeacher
          ? _teacherNavPages[navIndex]
          : _studentNavPages[navIndex],
    ),
  );
}

// Icons and labels for each Navigation Bar item
const _studentNavIcons = <Map<String, dynamic>>[
  {'icon': Icon(Icons.check_circle_outline), 'label': 'home'},
  {'icon': Icon(Icons.class_), 'label': 'my classes'},
  {'icon': Icon(Icons.calendar_today), 'label': 'schedule'},
];

// Screen that each Navigation Bar item displays
const _studentNavPages = <Widget>[
  AssignmentList(),
  CourseList(),
  CalendarPage(),
];

const _teacherNavIcons = <Map<String, dynamic>>[
  // TODO: {'icon': Icon(Icons.check_circle_outline), 'label': 'teacher home'},
  {'icon': Icon(Icons.class_), 'label': 'classes'},
  {'icon': Icon(Icons.calendar_today), 'label': 'teacher schedule'},
];

const _teacherNavPages = <Widget>[
  // TODO: Center(child: Text('Page 1')),
  CourseList(),
  Center(child: Text('Page 3')),
];
