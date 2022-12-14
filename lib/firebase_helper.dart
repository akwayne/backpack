import 'package:cloud_firestore/cloud_firestore.dart';

import 'assignment/model/assignment.dart';
import 'course/model/course.dart';
import 'user/model/app_user.dart';

class FirebaseHelper {
  late FirebaseFirestore firestore;
  late CollectionReference courses;
  late CollectionReference assignments;
  late CollectionReference users;

  FirebaseHelper() {
    firestore = FirebaseFirestore.instance;
    courses = firestore.collection('courses');
    assignments = firestore.collection('assignments');
    users = firestore.collection('users');
  }

  Future<List<Course>> readCourses() async {
    final snapshot = await courses.get();
    final courseList = <Course>[];

    for (var item in snapshot.docs) {
      final course =
          Course.fromMap(item.data() as Map<String, dynamic>, item.id);
      courseList.add(course);
    }
    return courseList;
  }

  // Assignment Actions
  Future<List<Assignment>> readAssignments() async {
    final snapshot = await assignments.get();
    final assignmentList = <Assignment>[];

    for (var item in snapshot.docs) {
      final assignment =
          Assignment.fromMap(item.data() as Map<String, dynamic>, item.id);
      assignmentList.add(assignment);
    }
    return assignmentList;
  }

  // Returns the id generated by firebase
  Future insertAssignment(Assignment assignment) async {
    final newAssignmentId = assignments.doc();
    await newAssignmentId.set(assignment.toMap());
  }

  Future deleteAssignment(String assignmentId) async {
    await assignments.doc(assignmentId).delete();
  }

  // User actions
  Future<AppUser> readUser(String userId) async {
    final snapshot = await users.doc(userId).get();

    // Return user entry from database
    final user =
        AppUser.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);

    return user;
  }

  Future insertUser(AppUser user) async {
    await users.doc(user.id).set(user.toMap());
  }

  Future updateUser(AppUser user) async {
    await users.doc(user.id).update(user.toMap());
  }

  Future deleteUser(String userId) async {
    // delete user from database
    await users.doc(userId).delete();
  }
}
