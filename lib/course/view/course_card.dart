import 'package:flutter/material.dart';

import '../model/course.dart';
import '../model/subject.dart';

// Displays a card for each course enrolled in
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: course.subject.getColor,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 8,
              right: 16,
              child: Image.asset(
                course.subject.getImage,
                color: const Color.fromRGBO(255, 255, 255, 0.5),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    course.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: course.subject.getTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    course.teacher,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: course.subject.getTextColor,
                          height: 1.8,
                        ),
                  ),
                  Text(
                    course.location,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: course.subject.getTextColor,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
