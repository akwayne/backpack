class Assignment {
  final String id;
  final String courseId;
  final String name;
  final bool submissionRequired;
  final String instructions;

  Assignment({
    required this.id,
    required this.courseId,
    required this.name,
    required this.submissionRequired,
    required this.instructions,
  });

  factory Assignment.fromDatabase(Map<String, dynamic> row, String id) {
    return Assignment(
      id: id,
      courseId: row['courseId'] as String,
      name: row['name'] as String,
      submissionRequired: row['submissionRequired'] as bool,
      instructions: row['instructions'] as String,
    );
  }

  Map<String, dynamic> toDatabase() {
    return <String, dynamic>{
      'courseId': courseId,
      'name': name,
      'submissionRequired': submissionRequired,
      'instructions': instructions,
    };
  }
}
