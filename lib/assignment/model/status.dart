class Status {
  String studentId;
  String assignmentId;
  bool isComplete;

  Status({
    required this.studentId,
    required this.assignmentId,
    required this.isComplete,
  });

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      studentId: map['studentId'] as String,
      assignmentId: map['assignmentId'] as String,
      isComplete: map['isComplete'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentId': studentId,
      'assignmentId': assignmentId,
      'isComplete': isComplete,
    };
  }
}
