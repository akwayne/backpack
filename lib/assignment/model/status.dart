class Status {
  String assignmentId;
  bool isComplete;

  Status({
    required this.assignmentId,
    required this.isComplete,
  });

  factory Status.fromMap(Map<String, dynamic> map, String assignmentId) {
    return Status(
      assignmentId: assignmentId,
      isComplete: map['isComplete'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isComplete': isComplete,
    };
  }
}
