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
    this.displayName,
    this.photoUrl,
    required this.isTeacher,
    this.school,
    required this.courses,
    required this.completed,
  });

  factory UserDetail.none() {
    return UserDetail(
      id: '',
      isTeacher: false,
      courses: [],
      completed: [],
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
      courses: map['courses'] as List<dynamic>,
      completed: map['completed'] as List<dynamic>,
      school: map['school'] as String?,
    );
  }

  Map<String, dynamic> toDatabase() {
    return <String, dynamic>{
      'isTeacher': isTeacher,
      'courses': courses,
      'completed': completed,
      'school': school,
    };
  }
}
