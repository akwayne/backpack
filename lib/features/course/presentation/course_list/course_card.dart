import 'package:backpack/features/course/course.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Displays a card for each course enrolled in
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = getDeviceType(MediaQuery.of(context));

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'course',
          params: {'courseId': course.courseId},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(22.0)),
        ),
        child: Row(
          children: [
            Container(
              padding: deviceType == DeviceType.mobile
                  ? const EdgeInsets.all(8)
                  : const EdgeInsets.all(12.0),
              // Make icon smaller on phones
              width: deviceType == DeviceType.mobile ? 80 : null,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(22.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    course.subject.getColor.withOpacity(0.6),
                    course.subject.getColor,
                  ],
                ),
              ),
              child: Image.asset(
                course.subject.getImage,
                color: const Color.fromRGBO(255, 255, 255, 0.8),
                colorBlendMode: BlendMode.modulate,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.bold,
                          // Use slightly smaller font for phones
                          fontSize: deviceType == DeviceType.mobile ? 20 : null,
                        ),
                  ),
                  Text(
                    course.teacherName,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).hintColor,
                          height: 1.8,
                        ),
                  ),
                  Text(
                    course.location,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).hintColor,
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
