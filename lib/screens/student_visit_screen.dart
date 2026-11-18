import 'package:flutter/material.dart';

import '../models/clinic_repository.dart';
import '../models/clinic_visit.dart';
import '../widgets/visit_form.dart';
import 'nurse_queue_screen.dart';

class StudentVisitScreen extends StatefulWidget {
  const StudentVisitScreen({super.key});

  @override
  State<StudentVisitScreen> createState() => _StudentVisitScreenState();
}

class _StudentVisitScreenState extends State<StudentVisitScreen> {
  final _repository = ClinicRepository();
  final List<ClinicVisit> _seedVisits = ClinicVisit.dummyVisits
      .map(
        (visit) => ClinicVisit(
          id: visit.id,
          studentName: visit.studentName,
          studentId: visit.studentId,
          symptom: visit.symptom,
          visitedAt: visit.visitedAt,
          status: visit.status,
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    await _repository.initialize();
    if (mounted) setState(() {});
  }

  void _openNurseView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NurseQueueScreen(
          repository: _repository,
          seededVisits: _seedVisits,
          onMarkAttended: (visit) {
            setState(() => visit.status = VisitStatus.attended);
            _repository.markAttended(visit.id);
          },
        ),
      ),
    );
  }

  void _addVisit({
    required String name,
    required String id,
    required String symptom,
  }) {
    setState(() {
      _seedVisits.insert(
        0,
        ClinicVisit(
          id: 'visit-${DateTime.now().millisecondsSinceEpoch}',
          studentName: name,
          studentId: id,
          symptom: symptom,
          visitedAt: DateTime.now(),
        ),
      );
    });
    _repository.addVisit(studentName: name, studentId: id, symptom: symptom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Clinic'),
        actions: [
          IconButton(
            tooltip: 'Nurse view',
            onPressed: _openNurseView,
            icon: const Icon(Icons.local_hospital_outlined),
          ),
        ],
      ),
      body: VisitForm(
        firebaseReady: _repository.firebaseReady,
        onSubmit: _addVisit,
      ),
    );
  }
}
