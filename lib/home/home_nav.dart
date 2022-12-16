import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../assignment/view/components/assignment_list.dart';
import '../calendar/calendar_page.dart';
import '../course/view/components/course_list.dart';
import '../user/model/app_user.dart';
import '../user/view/components/user_name_tile.dart';
import '../user/viewmodel/user_provider.dart';
import '../utilities/utilities.dart';
import 'cloud_future_builder.dart';

final _homeNavIndexProvider = StateProvider<int>((ref) => 0);

class HomeNavigation extends ConsumerWidget {
  const HomeNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user information
    final user = ref.watch(userProvider) ?? AppUser.empty();

    // Get nav icons for student or teacher view of homepage
    final navIcons = user.isTeacher ? _teacherNavIcons : _studentNavIcons;

    // Current tab index
    final navIndex = ref.watch(_homeNavIndexProvider);

    // Function for updating home page tab
    void updateTab(index) {
      ref.read(_homeNavIndexProvider.notifier).state = index;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
            ? _HomeMobileView(
                user: user,
                navIcons: navIcons,
                navIndex: navIndex,
                updateTab: updateTab,
              )
            : _HomeTabletView(
                user: user,
                navIcons: navIcons,
                navIndex: navIndex,
                updateTab: updateTab,
              );
      },
    );
  }
}

class _HomeMobileView extends StatelessWidget {
  const _HomeMobileView({
    required this.user,
    required this.navIcons,
    required this.navIndex,
    required this.updateTab,
  });

  final AppUser user;
  final List<Map> navIcons;
  final int navIndex;
  final Function updateTab;

  @override
  Widget build(BuildContext context) {
    // Determine if phone is in portrait or landscape mode
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        // Hide drawer icon in portrait mode
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
                      updateTab(index);
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
              onTap: (index) => updateTab(index),
              items: [
                for (var item in navIcons)
                  BottomNavigationBarItem(
                    icon: item['icon'],
                    label: item['label'],
                  ),
              ],
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
}

class _HomeTabletView extends StatelessWidget {
  const _HomeTabletView({
    required this.user,
    required this.navIcons,
    required this.navIndex,
    required this.updateTab,
  });

  final AppUser user;
  final List<Map> navIcons;
  final int navIndex;
  final Function updateTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // Navigation Rail
          CustomNavRail(
            navIndex: navIndex,
            updateTab: updateTab,
            navIcons: navIcons,
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
}

// Builds page based on tab selection
Widget _buildNavPage(int navIndex, AppUser user) {
  return CustomFade(
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
  {'icon': Icon(Icons.class_), 'label': 'classes'},
  {'icon': Icon(Icons.calendar_today), 'label': 'calendar'},
];

const _teacherNavPages = <Widget>[
  CourseList(),
  Center(child: Text('Page 3')),
];
