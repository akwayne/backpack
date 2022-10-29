// Assignment id is unique to each assignment
class Assignment {
  String? id;
  String courseId;
  String name;
  bool submissionRequired;
  String instructions;

  Assignment({
    required this.id,
    required this.courseId,
    required this.name,
    required this.submissionRequired,
    required this.instructions,
  });

  factory Assignment.fromMap(Map<String, dynamic> map, String id) {
    return Assignment(
      id: id,
      courseId: map['courseId'] as String,
      name: map['name'] as String,
      submissionRequired: map['submissionRequired'] as bool,
      instructions: map['instructions'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseId': courseId,
      'name': name,
      'submissionRequired': submissionRequired,
      'instructions': instructions,
    };
  }
}
