import 'package:backpack/user_repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/course.dart';

final courseProvider = StateNotifierProvider<CourseNotifier, List<Course>>(
    (ref) => CourseNotifier(ref.watch(userRepositoryProvider)));

class CourseNotifier extends StateNotifier<List<Course>> {
  CourseNotifier(this.repository) : super([]);

  final UserRepository repository;

  // Only checks on app startup
  Future<void> getCourses() async {
    if (state.isEmpty) {
      final courseList = await repository.getCourses();
      state = [for (Course course in courseList) course];
    }
  }

// TODO get this stuff
  Course getCourseFromId(String courseId) {
    final index = state.indexWhere((element) => element.id == courseId);
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
