import 'package:backpack/features/course/course.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseServiceProvider =
    StateNotifierProvider<CourseServiceNotifier, List<Course>>(
        (ref) => CourseServiceNotifier(ref.read(courseRepositoryProvider)));

class CourseServiceNotifier extends StateNotifier<List<Course>> {
  CourseServiceNotifier(this.repository) : super([]);

  final CourseRepository repository;

  // Set a list of courses to the state
  set setCourses(List<Course> courses) =>
      state = [for (final course in courses) course];

  // trigger repository to get courses from firebase
  Future<void> getCourses() async {
    await repository.getCourses();
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
