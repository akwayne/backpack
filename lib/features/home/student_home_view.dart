import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';
import 'home_appbar.dart';
import 'nav_drawer.dart';

class StudentHomeView extends StatelessWidget {
  const StudentHomeView(this.user, {super.key});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(MediaQuery.of(context));
    final orientation = MediaQuery.of(context).orientation;
    return deviceType == DeviceType.mobile
        ? _buildMobileView(orientation)
        : _buildTabletView(orientation);
  }

  Widget _buildMobileView(Orientation orientation) {
    return Scaffold(
      appBar: HomeAppBar(user: user),
      body: Container(),
      bottomNavigationBar: (orientation == Orientation.portrait)
          ? HomeBottomNavBar(navPages: _navPages)
          : null,
      drawer: (orientation == Orientation.landscape)
          ? HomeNavDrawer(navPages: _navPages)
          : null,
    );
  }

  Widget _buildTabletView(Orientation orientation) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // TODO Add NavRail Here
          Expanded(
            child: SafeArea(
              child: Column(children: <Widget>[
                // TODO User Name Row here
                Expanded(
                  child:
                      // TODO Nav Page Here
                      Container(),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

final _navPages = <Map<String, dynamic>>[
  {
    'page': Container(),
    'icon': const Icon(Icons.check_circle_outline),
    'label': 'home',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.class_),
    'label': 'my classes',
  },
  {
    'page': Container(),
    'icon': const Icon(Icons.calendar_today),
    'label': 'schedule',
  },
];
