import 'package:flutter/material.dart';

import '../models/clinic_repository.dart';
import '../models/clinic_visit.dart';
import '../widgets/queue_list.dart';

class NurseQueueScreen extends StatelessWidget {
  const NurseQueueScreen({
    super.key,
    required this.repository,
    required this.seededVisits,
    required this.onMarkAttended,
  });

  final ClinicRepository repository;
  final List<ClinicVisit> seededVisits;
  final ValueChanged<ClinicVisit> onMarkAttended;

  @override
  Widget build(BuildContext context) {
    final stream = repository.visitStream();

    return Scaffold(
      appBar: AppBar(title: const Text('Clinic queue')),
      body: stream == null
          ? QueueList(visits: seededVisits, onMarkAttended: onMarkAttended)
          : StreamBuilder<List<ClinicVisit>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return QueueList(
                    visits: seededVisits,
                    onMarkAttended: onMarkAttended,
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('No visits in the queue'));
                }
                return QueueList(
                  visits: snapshot.data!,
                  onMarkAttended: onMarkAttended,
                );
              },
            ),
    );
  }
}
