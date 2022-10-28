import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_helper.dart';
import '../model/course.dart';

// What the UI will call
final courseProvider =
    StateNotifierProvider<CourseNotifier, List<Course>>((ref) {
  return CourseNotifier();
});

class CourseNotifier extends StateNotifier<List<Course>> {
  CourseNotifier() : super([]);

  // TODO update more often than just when app opens
  Future<List<Course>> getCourses() async {
    // If state does not have courses saved in it yet
    if (state.isEmpty) {
      // Get courses from Firebase
      final courseList = await FirebaseHelper().readCourses();
      state.addAll(courseList);
    }
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

    return selectedCourses;
  }
}
