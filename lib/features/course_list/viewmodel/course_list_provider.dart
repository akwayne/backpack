import 'package:backpack/models/models.dart';
import 'package:backpack/user_service/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseListProvider =
    StateNotifierProvider<CourseListNotifier, List<Course>>(
        (ref) => CourseListNotifier(ref.watch(userServiceProvider)));

class CourseListNotifier extends StateNotifier<List<Course>> {
  CourseListNotifier(this.service) : super([]);

  final UserService service;

  // Set a list of courses to the state
  set setCourses(List<Course> courses) =>
      state = [for (final course in courses) course];

  // trigger repository to get courses from firebase
  Future<void> getCourses() async {
    await service.getCourses();
  }

  // clear courses from state
  void clearCourses() {
    state.clear();
  }

  // Get a course from the current state by id
  Course getCourseById(String id) {
    final index = state.indexWhere((element) => element.id == id);
    return state[index];
  }

  // TODO
  List<Course> getCoursesSelectedDay(DateTime selectedDay) {
    List<Course> selectedCourses = state
        .where((course) => course.weekdayList.contains(selectedDay.weekday))
        .toList();

    // Sort list to display by time
    selectedCourses.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

    return selectedCourses;
  }
}