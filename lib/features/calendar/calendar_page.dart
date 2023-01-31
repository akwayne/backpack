import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../course/model/course.dart';
import '../../course/viewmodel/course_provider.dart';
import '../../utilities/utilities.dart';
import 'calendar_event_card.dart';
import 'calendar_widget.dart';

// Provider stores selected date on calendar
final calendarStateProvider =
    StateProvider<DateTime>(((ref) => DateTime.now()));

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get selected day from provider
    final DateTime selectedDay = ref.watch(calendarStateProvider);

    // How to format date to a string
    // https://api.flutter.dev/flutter/intl/DateFormat-class.html
    String formattedDate = DateFormat('EEEE, MMM d').format(selectedDay);

    final selectedDayCourses =
        ref.read(courseProvider.notifier).getCoursesSelectedDay(selectedDay);

    return LayoutBuilder(builder: (context, constraints) {
      return getDeviceType(MediaQuery.of(context)) == DeviceType.mobile
          ? _buildMobileView(context, formattedDate, selectedDayCourses)
          : _buildTabletView(context, formattedDate, selectedDayCourses);
    });
  }
}

Widget _buildMobileView(
  BuildContext context,
  String selectedDay,
  List<Course> courses,
) {
  return ListView(
    children: <Widget>[
      const CalendarWidget(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          selectedDay,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      ListView.builder(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: courses.length,
        itemBuilder: (context, index) => EventCard(
          course: courses[index],
        ),
      ),
    ],
  );
}

Widget _buildTabletView(
  BuildContext context,
  String selectedDay,
  List<Course> courses,
) {
  return Row(
    children: <Widget>[
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Text(
              selectedDay,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) => EventCard(
                  course: courses[index],
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 28),
      Expanded(
        flex: 4,
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 20),
              ],
            ),
            const CalendarWidget(),
          ],
        ),
      ),
    ],
  );
}
