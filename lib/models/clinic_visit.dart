enum VisitStatus { waiting, attended }

class ClinicVisit {
  ClinicVisit({
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
  VisitStatus status;

  static final List<ClinicVisit> dummyVisits = [
    ClinicVisit(
      id: 'seed-1',
      studentName: 'Mia Thompson',
      studentId: 'ST-2024-148',
      symptom: 'Headache and dizziness',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    ClinicVisit(
      id: 'seed-2',
      studentName: 'Ethan Cole',
      studentId: 'ST-2024-092',
      symptom: 'Stomach discomfort',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 21)),
    ),
    ClinicVisit(
      id: 'seed-3',
      studentName: 'Sofia Ramirez',
      studentId: 'ST-2024-231',
      symptom: 'Minor ankle pain',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 34)),
    ),
    ClinicVisit(
      id: 'seed-4',
      studentName: 'Noah Williams',
      studentId: 'ST-2024-186',
      symptom: 'Sore throat',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 42)),
    ),
    ClinicVisit(
      id: 'seed-5',
      studentName: 'Ava Martinez',
      studentId: 'ST-2024-205',
      symptom: 'Fever',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 55)),
    ),
    ClinicVisit(
      id: 'seed-6',
      studentName: 'Liam Anderson',
      studentId: 'ST-2024-077',
      symptom: 'Allergy symptoms',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 63)),
    ),
    ClinicVisit(
      id: 'seed-7',
      studentName: 'Isabella Clark',
      studentId: 'ST-2024-304',
      symptom: 'Skin irritation',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 71)),
    ),
    ClinicVisit(
      id: 'seed-8',
      studentName: 'Lucas Brown',
      studentId: 'ST-2024-118',
      symptom: 'Back pain',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 79)),
    ),
    ClinicVisit(
      id: 'seed-9',
      studentName: 'Amelia Davis',
      studentId: 'ST-2024-252',
      symptom: 'Dizziness',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 88)),
    ),
    ClinicVisit(
      id: 'seed-10',
      studentName: 'James Wilson',
      studentId: 'ST-2024-160',
      symptom: 'Cough and cold',
      visitedAt: DateTime.now().subtract(const Duration(minutes: 96)),
    ),
  ];
}
