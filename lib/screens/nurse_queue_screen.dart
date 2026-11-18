import 'package:flutter/material.dart';

import '../models/clinic_repository.dart';
import '../models/clinic_visit.dart';
import '../widgets/queue_list.dart';

class NurseQueueScreen extends StatefulWidget {
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
  State<NurseQueueScreen> createState() => _NurseQueueScreenState();
}

class _NurseQueueScreenState extends State<NurseQueueScreen> {
  void _markAttended(ClinicVisit visit) {
    widget.onMarkAttended(visit);
    setState(() => visit.status = VisitStatus.attended);
  }

  @override
  Widget build(BuildContext context) {
    final stream = widget.repository.visitStream();

    return Scaffold(
      appBar: AppBar(title: const Text('Clinic queue')),
      body: stream == null
          ? QueueList(
              visits: widget.seededVisits,
              onMarkAttended: _markAttended,
            )
          : StreamBuilder<List<ClinicVisit>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return QueueList(
                    visits: widget.seededVisits,
                    onMarkAttended: _markAttended,
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
                  onMarkAttended: _markAttended,
                );
              },
            ),
    );
  }
}
