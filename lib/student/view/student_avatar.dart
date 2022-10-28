import 'package:flutter/material.dart';

import '../../utilities/utilities.dart';

class StudentAvatar extends StatelessWidget {
  const StudentAvatar({
    super.key,
    required this.imageRadius,
  });

  final double imageRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: imageRadius,
      child: CircleAvatar(
        // foregroundImage: const AssetImage('assets/profile_pics/cat.jpg'),
        backgroundColor: ColorPalette.turquoise,
        radius: imageRadius - 4,
      ),
    );
  }
}
