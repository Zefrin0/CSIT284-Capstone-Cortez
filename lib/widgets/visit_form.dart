import 'package:flutter/material.dart';

typedef VisitSubmitCallback =
    void Function({
      required String name,
      required String id,
      required String symptom,
    });

class VisitForm extends StatefulWidget {
  const VisitForm({
    super.key,
    required this.firebaseReady,
    required this.onSubmit,
  });

  final bool firebaseReady;
  final VisitSubmitCallback onSubmit;

  @override
  State<VisitForm> createState() => _VisitFormState();
}

class _VisitFormState extends State<VisitForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _symptomController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _symptomController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      name: _nameController.text.trim(),
      id: _idController.text.trim(),
      symptom: _symptomController.text.trim(),
    );
    _formKey.currentState!.reset();
    _nameController.clear();
    _idController.clear();
    _symptomController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Visit added to the clinic queue')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log a clinic visit',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter your student ID and a short symptom description.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student name',
                      border: OutlineInputBorder(),
                    ),
                    validator: _requiredValue,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                      hintText: 'ST-2024-100',
                      border: OutlineInputBorder(),
                    ),
                    validator: _requiredValue,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _symptomController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Symptom',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: _requiredValue,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.add),
                      label: const Text('Join clinic queue'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        widget.firebaseReady
                            ? Icons.cloud_done_outlined
                            : Icons.cloud_off_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.firebaseReady
                            ? 'Firebase connected'
                            : 'Demo mode',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValue(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }
}
