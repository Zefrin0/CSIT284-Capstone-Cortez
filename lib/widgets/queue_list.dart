import 'package:flutter/material.dart';

import '../models/clinic_visit.dart';

class QueueList extends StatelessWidget {
  const QueueList({
    super.key,
    required this.visits,
    required this.onMarkAttended,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ClinicVisit> visits;
  final ValueChanged<ClinicVisit> onMarkAttended;
  final ValueChanged<ClinicVisit> onEdit;
  final ValueChanged<ClinicVisit> onDelete;

  @override
  Widget build(BuildContext context) {
    if (visits.isEmpty) {
      return const Center(child: Text('No visits in the queue'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: visits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final visit = visits[index];
        final attended = visit.status == VisitStatus.attended;

        return Card(
          key: ValueKey(visit.id),
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(visit.studentName),
            subtitle: Text(
              '${visit.studentId}\n${visit.symptom}\n'
              '${_formatTime(visit.visitedAt)}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (attended)
                  const Chip(label: Text('Attended'))
                else
                  FilledButton(
                    onPressed: () => onMarkAttended(visit),
                    child: const Text('Attend'),
                  ),
                PopupMenuButton<String>(
                  tooltip: 'More actions',
                  onSelected: (value) {
                    if (value == 'edit') onEdit(visit);
                    if (value == 'delete') onDelete(visit);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _formatTime(DateTime time) {
  final hour = time.hour > 12
      ? time.hour - 12
      : (time.hour == 0 ? 12 : time.hour);
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}
