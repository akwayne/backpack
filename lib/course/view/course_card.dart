import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/course.dart';
import '../model/subject.dart';

// Displays a card for each course enrolled in
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.pushNamed(
            'course',
            params: {'courseId': course.courseId},
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                course.subject.getColor.withOpacity(0.4),
                course.subject.getColor,
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(22.0)),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 8,
                right: 16,
                child: Image.asset(
                  course.subject.getImage,
                  color: const Color.fromRGBO(255, 255, 255, 0.8),
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      course.teacher,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Colors.black54,
                            height: 1.8,
                          ),
                    ),
                    Text(
                      course.location,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Colors.black54,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
