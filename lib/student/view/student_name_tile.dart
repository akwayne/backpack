import 'package:flutter/material.dart';
import '../model/student.dart';
import 'student_avatar.dart';

class StudentNameTile extends StatelessWidget {
  const StudentNameTile({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile');
      },
      child: Row(
        children: [
          const StudentAvatar(imageRadius: 30),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${student.firstName} ${student.lastName}',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(student.school,
                  style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
