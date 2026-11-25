import 'package:capstone_cortez/models/clinic_repository.dart';
import 'package:capstone_cortez/models/clinic_visit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClinicRepository (demo mode) CRUD', () {
    late ClinicRepository repo;

    setUp(() => repo = ClinicRepository());
    tearDown(() => repo.dispose());

    test('create adds a waiting visit at the top of the queue', () async {
      await repo.addVisit(
        studentName: 'New Student',
        studentId: 'ST-1',
        symptom: 'Fever',
      );
      final visits = await repo.visitStream().first;
      expect(visits.first.studentName, 'New Student');
      expect(visits.first.status, VisitStatus.waiting);
      expect(visits.length, 11);
    });

    test('update edits the visit fields', () async {
      await repo.updateVisit(
        'seed-1',
        studentName: 'Renamed',
        studentId: 'ST-X',
        symptom: 'Cough',
      );
      final visits = await repo.visitStream().first;
      final updated = visits.firstWhere((v) => v.id == 'seed-1');
      expect(updated.studentName, 'Renamed');
      expect(updated.symptom, 'Cough');
    });

    test('markAttended changes status', () async {
      await repo.markAttended('seed-2');
      final visits = await repo.visitStream().first;
      expect(
        visits.firstWhere((v) => v.id == 'seed-2').status,
        VisitStatus.attended,
      );
    });

    test('delete removes the visit', () async {
      await repo.deleteVisit('seed-3');
      final visits = await repo.visitStream().first;
      expect(visits.any((v) => v.id == 'seed-3'), isFalse);
      expect(visits.length, 9);
    });
  });
}
