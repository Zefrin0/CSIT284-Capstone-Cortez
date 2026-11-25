import 'package:flutter/material.dart';

import '../models/clinic_repository.dart';
import '../widgets/visit_form.dart';
import 'nurse_queue_screen.dart';

class StudentVisitScreen extends StatelessWidget {
  const StudentVisitScreen({super.key, required this.repository});

  final ClinicRepository repository;

  void _openNurseView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NurseQueueScreen(repository: repository),
      ),
    );
  }

  Future<void> _addVisit({
    required String name,
    required String id,
    required String symptom,
  }) {
    return repository.addVisit(
      studentName: name,
      studentId: id,
      symptom: symptom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Clinic'),
        actions: [
          IconButton(
            tooltip: 'Nurse view',
            onPressed: () => _openNurseView(context),
            icon: const Icon(Icons.local_hospital_outlined),
          ),
        ],
      ),
      body: VisitForm(
        firebaseReady: repository.firebaseReady,
        onSubmit: _addVisit,
      ),
    );
  }
}
