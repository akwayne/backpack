class UserData {
  String id;
  String? displayName;
  String? photoUrl;
  bool isTeacher;
  List courses;
  List completed;
  String? school;

  UserData({
    required this.id,
    this.displayName,
    this.photoUrl,
    required this.isTeacher,
    required this.courses,
    required this.completed,
    this.school,
  });

  factory UserData.fromDatabase({
    required Map<String, dynamic> map,
    required String id,
    required String? displayName,
    required String? photoUrl,
  }) {
    return UserData(
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
