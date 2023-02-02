class UserDetail {
  String id;
  String? displayName;
  String? photoUrl;
  bool isTeacher;
  String? school;
  List courses;
  List completed;

  UserDetail({
    required this.id,
    required this.displayName,
    required this.photoUrl,
    required this.isTeacher,
    required this.school,
    required this.courses,
    required this.completed,
  });

  factory UserDetail.empty() {
    return UserDetail(
      id: '',
      displayName: null,
      photoUrl: null,
      isTeacher: false,
      school: null,
      courses: [],
      completed: [],
    );
  }

  // Makes an exact copy of itself
  UserDetail copy() {
    return UserDetail(
      id: id,
      displayName: displayName,
      photoUrl: photoUrl,
      isTeacher: isTeacher,
      school: school,
      courses: courses,
      completed: completed,
    );
  }

  factory UserDetail.fromDatabase({
    required Map<String, dynamic> map,
    required String id,
    required String? displayName,
    required String? photoUrl,
  }) {
    return UserDetail(
      id: id,
      displayName: displayName,
      photoUrl: photoUrl,
      isTeacher: map['isTeacher'] as bool,
      school: map['school'] as String?,
      courses: map['courses'] as List<dynamic>,
      completed: map['completed'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toDatabase() {
    return <String, dynamic>{
      'isTeacher': isTeacher,
      'school': school,
      'courses': courses,
      'completed': completed,
    };
  }
}
