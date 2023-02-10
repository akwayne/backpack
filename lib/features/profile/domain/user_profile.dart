class UserProfile {
  String id;
  String? displayName;
  String? photoUrl;
  bool isTeacher;
  String? school;
  List<String> courses;
  List<String> completed;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.photoUrl,
    required this.isTeacher,
    required this.school,
    required this.courses,
    required this.completed,
  });

  // Empty user profile object
  factory UserProfile.empty() {
    return UserProfile(
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
  UserProfile copy() {
    return UserProfile(
      id: id,
      displayName: displayName,
      photoUrl: photoUrl,
      isTeacher: isTeacher,
      school: school,
      courses: courses,
      completed: completed,
    );
  }

  factory UserProfile.fromDatabase({
    required Map<String, dynamic> row,
    required String id,
    required String? displayName,
    required String? photoUrl,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName,
      photoUrl: photoUrl,
      isTeacher: row['isTeacher'] as bool,
      school: row['school'] as String?,
      courses: List.castFrom(row['courses']),
      completed: List.castFrom(row['completed']),
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
