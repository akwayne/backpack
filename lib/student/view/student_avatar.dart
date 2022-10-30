import 'package:backpack/student/viewmodel/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/utilities.dart';
import '../model/student.dart';

class StudentAvatar extends ConsumerWidget {
  const StudentAvatar({
    super.key,
    required this.imageRadius,
  });

  final double imageRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider) ?? Student.empty();

    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: imageRadius,
      child: CircleAvatar(
        foregroundImage: NetworkImage(student.imageURL),
        backgroundColor: ColorPalette.turquoise,
        radius: imageRadius - 4,
      ),
    );
  }
}
