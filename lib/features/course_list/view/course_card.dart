import 'package:backpack/constants/constants.dart';
import 'package:backpack/models/models.dart';
import 'package:backpack/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseCard extends StatelessWidget {
  const CourseCard(this.course, {super.key});

  final Course course;

  @override
  Widget build(BuildContext context) {
    DeviceType deviceType = getDeviceType(MediaQuery.of(context));

    TextStyle subtitleStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).hintColor,
        );
    TextStyle titleStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        );

    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteName.course,
        params: {'id': course.id},
      ),
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
                    course.subject.color.withOpacity(0.6),
                    course.subject.color,
                  ],
                ),
              ),
              child: Image.asset(
                course.subject.image,
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
                    style: titleStyle,
                  ),
                  Text(
                    course.teacherName,
                    style: subtitleStyle,
                  ),
                  Text(
                    course.location,
                    style: subtitleStyle,
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
