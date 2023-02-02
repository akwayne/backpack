import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/course.dart';

final courseProvider = StateNotifierProvider<CourseNotifier, List<Course>>(
    (ref) => CourseNotifier(FirebaseHelper(), ref));

class CourseNotifier extends StateNotifier<List<Course>> {
  CourseNotifier(this.firebaseHelper, this.ref) : super([]);

  final FirebaseHelper firebaseHelper;
  final Ref ref;

  // User info from profile provider
  UserDetail get user => ref.read(profileProvider.notifier).user;

  // Only checks on app startup
  Future<void> getCourses() async {
    if (state.isEmpty) {
      final courseList = await firebaseHelper.readCourses(user.courses);
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
