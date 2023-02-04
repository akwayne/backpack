import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';
import 'home_appbar.dart';
import 'nav_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.user,
    required this.navPages,
  });

  final UserProfile user;
  final List<Map<String, dynamic>> navPages;

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
          ? HomeBottomNavBar(navPages: navPages)
          : null,
      drawer: (orientation == Orientation.landscape)
          ? HomeNavDrawer(navPages: navPages)
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
