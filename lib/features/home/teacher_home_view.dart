import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';

class TeacherHomeView extends StatelessWidget {
  const TeacherHomeView(this.user, {super.key});

  final UserProfile user;
  @override
  Widget build(BuildContext context) {
    return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
        ? _buildMobileView()
        : _buildTabletView();
  }

  Widget _buildMobileView() {
    return Container();
  }

  Widget _buildTabletView() {
    return Container();
  }
}
