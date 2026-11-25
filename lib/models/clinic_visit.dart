enum VisitStatus { waiting, attended }

class ClinicVisit {
  const ClinicVisit({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.symptom,
    required this.visitedAt,
    this.status = VisitStatus.waiting,
  });

  final String id;
  final String studentName;
  final String studentId;
  final String symptom;
  final DateTime visitedAt;
  final VisitStatus status;

  ClinicVisit copyWith({
    String? studentName,
    String? studentId,
    String? symptom,
    VisitStatus? status,
  }) {
    return ClinicVisit(
      id: id,
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      symptom: symptom ?? this.symptom,
      visitedAt: visitedAt,
      status: status ?? this.status,
    );
  }
}
