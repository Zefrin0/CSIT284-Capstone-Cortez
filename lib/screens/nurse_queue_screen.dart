import 'package:flutter/material.dart';

import '../models/clinic_repository.dart';
import '../models/clinic_visit.dart';
import '../widgets/app_background.dart';
import '../widgets/edit_visit_dialog.dart';
import '../widgets/queue_list.dart';

class NurseQueueScreen extends StatelessWidget {
  const NurseQueueScreen({super.key, required this.repository});

  final ClinicRepository repository;

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
    String successMessage,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Something went wrong: $error')),
      );
    }
  }

  Future<void> _markAttended(BuildContext context, ClinicVisit visit) {
    return _run(
      context,
      () => repository.markAttended(visit.id),
      '${visit.studentName} marked as attended',
    );
  }

  Future<void> _edit(BuildContext context, ClinicVisit visit) async {
    final result = await showEditVisitDialog(context, visit);
    if (result == null || !context.mounted) return;

    await _run(
      context,
      () => repository.updateVisit(
        visit.id,
        studentName: result.name,
        studentId: result.studentId,
        symptom: result.symptom,
      ),
      'Visit updated',
    );
  }

  Future<void> _delete(BuildContext context, ClinicVisit visit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete visit?'),
        content: Text(
          'Remove ${visit.studentName} (${visit.studentId}) from the queue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await _run(
      context,
      () => repository.deleteVisit(visit.id),
      'Visit deleted',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinic queue')),
      body: AppBackground(
        child: StreamBuilder<List<ClinicVisit>>(
          stream: repository.visitStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Could not load the queue.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return QueueList(
              visits: snapshot.data!,
              onMarkAttended: (visit) => _markAttended(context, visit),
              onEdit: (visit) => _edit(context, visit),
              onDelete: (visit) => _delete(context, visit),
            );
          },
        ),
      ),
    );
  }
}