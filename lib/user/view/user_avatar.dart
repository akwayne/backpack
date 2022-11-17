import 'package:flutter/material.dart';

import '../../utilities/utilities.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.imageRadius,
    required this.image,
  });

  final double imageRadius;
  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: imageRadius,
      child: CircleAvatar(
        foregroundImage: image,
        backgroundColor: ColorPalette.turquoise,
        radius: imageRadius - 4,
      ),
    );
  }
}
