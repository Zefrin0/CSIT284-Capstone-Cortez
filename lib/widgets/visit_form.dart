import 'package:flutter/material.dart';

import 'pulse_heart.dart';

typedef VisitSubmitCallback =
    Future<void> Function({
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
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _symptomController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(
        name: _nameController.text.trim(),
        id: _idController.text.trim(),
        symptom: _symptomController.text.trim(),
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
      _nameController.clear();
      _idController.clear();
      _symptomController.clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Visit added to the clinic queue')),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not save visit: $error')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  InputDecoration _decoration(String label, IconData icon, {String? hint}) {
    final primary = Theme.of(context).colorScheme.primary;
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF4F8F6),
      border: border(Colors.transparent, 0),
      enabledBorder: border(Colors.transparent, 0),
      focusedBorder: border(primary, 2),
      errorBorder: border(Colors.red.shade400, 1),
      focusedErrorBorder: border(Colors.red.shade400, 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: scheme.primaryContainer,
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Log a clinic visit',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Enter your student ID and a short symptom description.',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: scheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              'Student name',
                              Icons.person_outline,
                            ),
                            validator: _requiredValue,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _idController,
                            textInputAction: TextInputAction.next,
                            decoration: _decoration(
                              'Student ID',
                              Icons.badge_outlined,
                              hint: 'ST-2024-100',
                            ),
                            validator: _requiredValue,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _symptomController,
                            minLines: 3,
                            maxLines: 5,
                            decoration: _decoration(
                              'Symptom',
                              Icons.healing_outlined,
                            ).copyWith(alignLabelWithHint: true),
                            validator: _requiredValue,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _submitting ? null : _submit,
                              icon: _submitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.add),
                              label: const Text('Join clinic queue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(child: _ConnectionPill(ready: widget.firebaseReady)),
                const SizedBox(height: 32),
                const Center(child: PulseHeart(size: 200)),
                const SizedBox(height: 24),
              ],
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

class _ConnectionPill extends StatelessWidget {
  const _ConnectionPill({required this.ready});

  final bool ready;

  @override
  Widget build(BuildContext context) {
    final color = ready ? Colors.green.shade700 : Colors.orange.shade800;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ready ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            ready ? 'Firebase connected' : 'Demo mode',
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}