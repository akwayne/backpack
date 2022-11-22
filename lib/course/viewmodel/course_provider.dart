import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_helper.dart';
import '../../user/model/app_user.dart';
import '../model/course.dart';

// What the UI will call
final courseProvider =
    StateNotifierProvider<CourseNotifier, List<Course>>((ref) {
  return CourseNotifier();
});

class CourseNotifier extends StateNotifier<List<Course>> {
  CourseNotifier() : super([]);

  Future<List<Course>> getCourses(AppUser user) async {
    state.clear();

    final courseList = await FirebaseHelper().readCourses();

    // Select only courses that user teaches or is enrolled in
    state = courseList
        .where((course) => user.courses.contains(course.courseId))
        .toList();

    return state;
  }

  Course getCourseFromId(String courseId) {
    final index = state.indexWhere((element) => element.courseId == courseId);
    return state[index];
  }

  List<Course> getCoursesSelectedDay(DateTime selectedDay) {
    List<Course> selectedCourses = state
        .where((course) => course.weekdayList.contains(selectedDay.weekday))
        .toList();

    // Sort list to display by time
    selectedCourses.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

    return selectedCourses;
  }
}
