import '../models/clinic_visit.dart';

/// Seed data used only when Firebase is not configured (demo mode).
List<ClinicVisit> buildDemoVisits() {
  final now = DateTime.now();
  ClinicVisit v(String id, String name, String studentId, String symptom,
      int minutesAgo) {
    return ClinicVisit(
      id: id,
      studentName: name,
      studentId: studentId,
      symptom: symptom,
      visitedAt: now.subtract(Duration(minutes: minutesAgo)),
    );
  }

  return [
    v('seed-1', 'Mia Thompson', 'ST-2024-148', 'Headache and dizziness', 8),
    v('seed-2', 'Ethan Cole', 'ST-2024-092', 'Stomach discomfort', 21),
    v('seed-3', 'Sofia Ramirez', 'ST-2024-231', 'Minor ankle pain', 34),
    v('seed-4', 'Noah Williams', 'ST-2024-186', 'Sore throat', 42),
    v('seed-5', 'Ava Martinez', 'ST-2024-205', 'Fever', 55),
    v('seed-6', 'Liam Anderson', 'ST-2024-077', 'Allergy symptoms', 63),
    v('seed-7', 'Isabella Clark', 'ST-2024-304', 'Skin irritation', 71),
    v('seed-8', 'Lucas Brown', 'ST-2024-118', 'Back pain', 79),
    v('seed-9', 'Amelia Davis', 'ST-2024-252', 'Dizziness', 88),
    v('seed-10', 'James Wilson', 'ST-2024-160', 'Cough and cold', 96),
  ];
}
