import 'package:flutter/material.dart';

import '../models/clinic_visit.dart';

class EditedVisit {
  const EditedVisit({
    required this.name,
    required this.studentId,
    required this.symptom,
  });

  final String name;
  final String studentId;
  final String symptom;
}

/// Shows an edit dialog. Returns null if the user cancels.
Future<EditedVisit?> showEditVisitDialog(
  BuildContext context,
  ClinicVisit visit,
) {
  return showDialog<EditedVisit>(
    context: context,
    builder: (context) => _EditVisitDialog(visit: visit),
  );
}

class _EditVisitDialog extends StatefulWidget {
  const _EditVisitDialog({required this.visit});

  final ClinicVisit visit;

  @override
  State<_EditVisitDialog> createState() => _EditVisitDialogState();
}

class _EditVisitDialogState extends State<_EditVisitDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.visit.studentName);
  late final _idController =
      TextEditingController(text: widget.visit.studentId);
  late final _symptomController =
      TextEditingController(text: widget.visit.symptom);

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _symptomController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      EditedVisit(
        name: _nameController.text.trim(),
        studentId: _idController.text.trim(),
        symptom: _symptomController.text.trim(),
      ),
    );
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit visit'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Student name'),
                validator: _required,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Student ID'),
                validator: _required,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _symptomController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Symptom'),
                validator: _required,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
