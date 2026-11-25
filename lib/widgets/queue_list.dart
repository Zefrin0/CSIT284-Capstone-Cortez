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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            const Text('No visits in the queue'),
          ],
        ),
      );
    }

    final waiting = visits.where((v) => v.status == VisitStatus.waiting).length;
    final attended = visits.length - waiting;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: visits.length + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Waiting',
                      value: waiting,
                      icon: Icons.hourglass_top_rounded,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(
                      label: 'Attended',
                      value: attended,
                      icon: Icons.check_circle_outline,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              );
            }
            return _VisitCard(
              key: ValueKey(visits[index - 1].id),
              visit: visits[index - 1],
              onMarkAttended: onMarkAttended,
              onEdit: onEdit,
              onDelete: onDelete,
            );
          },
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(
            '$value',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({
    super.key,
    required this.visit,
    required this.onMarkAttended,
    required this.onEdit,
    required this.onDelete,
  });

  final ClinicVisit visit;
  final ValueChanged<ClinicVisit> onMarkAttended;
  final ValueChanged<ClinicVisit> onEdit;
  final ValueChanged<ClinicVisit> onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final attended = visit.status == VisitStatus.attended;
    final statusColor =
        attended ? Colors.green.shade700 : Colors.orange.shade800;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: Text(_initials(visit.studentName)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visit.studentName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        visit.studentId,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    attended ? 'Attended' : 'Waiting',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.healing_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(visit.symptom)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 8),
                Text(_formatTime(visit.visitedAt)),
                const Spacer(),
                if (!attended)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilledButton.tonalIcon(
                      onPressed: () => onMarkAttended(visit),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Attend'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  return parts.take(2).map((p) => p[0].toUpperCase()).join();
}

String _formatTime(DateTime time) {
  final hour = time.hour > 12
      ? time.hour - 12
      : (time.hour == 0 ? 12 : time.hour);
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}