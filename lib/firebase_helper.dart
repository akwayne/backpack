import 'package:cloud_firestore/cloud_firestore.dart';

import 'assignment/model/assignment.dart';
import 'course/model/course.dart';
import 'user/model/app_user.dart';
import 'user/model/student.dart';

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

  // User actions
  Future<Student> readStudent(String userId) async {
    final snapshot = await users.doc(userId).get();

    // Return student entry from database
    final student =
        Student.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);

    return student;
  }

  Future insertStudent(Student student) async {
    await users.doc(student.id).set(student.toMap());
  }

  Future updateStudent(Student student) async {
    await users.doc(student.id).update(student.toMap());
  }

  Future deleteStudent(String userId) async {
    // delete user from database
    await users.doc(userId).delete();
  }
}
