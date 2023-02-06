import 'package:backpack/features/course/course.dart';
import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseRepositoryProvider = Provider<CourseRepository>(
    (ref) => CourseRepository(ref.watch(firebaseHelperProvider), ref));

// Contacts Firebase
class CourseRepository {
  CourseRepository(this.firebaseHelper, this.ref);

  final FirebaseHelper firebaseHelper;
  final Ref ref;

  UserProfile _getProfile() => ref.read(profileProvider.notifier).getProfile;

  void _setCourses(List<Course> courses) =>
      ref.read(courseServiceProvider.notifier).setCourses = courses;

  /// Gets active user's course list from Firebase and sends to course provider
  Future<void> getCourses() async {
    final userProfile = _getProfile();
    final courses = await firebaseHelper.readCourses(userProfile.courses);
    _setCourses(courses);
  }
}
