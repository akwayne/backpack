import 'package:backpack/features/profile/profile.dart';
import 'package:backpack/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  FirebaseHelper() {
    firestore = FirebaseFirestore.instance;
    users = firestore.collection('users');
    courses = firestore.collection('courses');
    assignments = firestore.collection('assignments');
  }
  late FirebaseFirestore firestore;
  late CollectionReference users;
  late CollectionReference courses;
  late CollectionReference assignments;

  // User Collection Actions //
  Future<Map<String, dynamic>> readUserProfile(String id) async {
    final snapshot = await users.doc(id).get();
    return snapshot.data() as Map<String, dynamic>;
  }

  Future insertUserProfile({required UserProfile userProfile}) async {
    await users.doc(userProfile.id).set(userProfile.toDatabase());
  }

  Future updateUserProfile(UserProfile userProfile) async {
    await users.doc(userProfile.id).update(userProfile.toDatabase());
  }

  Future deleteUserProfile(String id) async {
    await users.doc(id).delete();
  }

  // Course Collection Actions //
  // Read courses for a user's list of enrolled courseIds
  Future<List<Course>> readCourses(List<String> courseIds) async {
    final courseList = <Course>[];
    for (String id in courseIds) {
      final snapshot = await courses.doc(id).get();
      final course = Course.fromDatabase(
          snapshot.data() as Map<String, dynamic>, snapshot.id);
      courseList.add(course);
    }
    return courseList;
  }

  // Assignment Collection Actions //
  // Read assignments for a user's list of enrolled courseIds
  Future<List<Assignment>> readAssignments(List<String> courseIds) async {
    final assignmentList = <Assignment>[];
    for (String courseId in courseIds) {
      final snapshot =
          await assignments.where('courseId', isEqualTo: courseId).get();
      final newAssignments = [
        for (final doc in snapshot.docs)
          Assignment.fromDatabase(doc.data() as Map<String, dynamic>, doc.id)
      ];
      assignmentList.addAll(newAssignments);
    }
    return assignmentList;
  }

  // TODO maybe update these
  Future insertAssignment(Assignment assignment) async {
    final newAssignmentId = assignments.doc();
    await newAssignmentId.set(assignment.toDatabase());
  }

  Future deleteAssignment(String assignmentId) async {
    await assignments.doc(assignmentId).delete();
  }
}
