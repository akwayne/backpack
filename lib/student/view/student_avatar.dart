import 'package:backpack/student/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/utilities.dart';

class StudentAvatar extends ConsumerWidget {
  const StudentAvatar({
    super.key,
    required this.imageRadius,
  });

  final double imageRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: imageRadius,
      child: FutureBuilder(
        future: ref.read(studentProvider.notifier).getImageURL(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircleAvatar(
              backgroundColor: ColorPalette.turquoise,
              radius: imageRadius - 4,
            );
          } else {
            return CircleAvatar(
              foregroundImage: NetworkImage(snapshot.data ?? ''),
              backgroundColor: ColorPalette.turquoise,
              radius: imageRadius - 4,
            );
          }
        },
      ),
    );
  }
}
