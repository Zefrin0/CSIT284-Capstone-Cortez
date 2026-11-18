import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'clinic_visit.dart';

class ClinicRepository {
  bool firebaseReady = false;
  FirebaseFirestore? _firestore;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _firestore = FirebaseFirestore.instance;
      firebaseReady = true;
    } catch (_) {
      firebaseReady = false;
    }
  }

  Stream<List<ClinicVisit>>? visitStream() {
    final firestore = _firestore;
    if (!firebaseReady || firestore == null) return null;

    return firestore
        .collection('clinic_visits')
        .orderBy('visitedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final timestamp = data['visitedAt'] as Timestamp?;
            return ClinicVisit(
              id: doc.id,
              studentName: data['studentName'] as String? ?? '',
              studentId: data['studentId'] as String? ?? '',
              symptom: data['symptom'] as String? ?? '',
              visitedAt: timestamp?.toDate() ?? DateTime.now(),
              status: data['status'] == 'attended'
                  ? VisitStatus.attended
                  : VisitStatus.waiting,
            );
          }).toList(),
        );
  }

  Future<void> addVisit({
    required String studentName,
    required String studentId,
    required String symptom,
  }) async {
    final firestore = _firestore;
    if (!firebaseReady || firestore == null) return;

    await firestore.collection('clinic_visits').add({
      'studentName': studentName,
      'studentId': studentId,
      'symptom': symptom,
      'visitedAt': Timestamp.now(),
      'status': 'waiting',
    });
  }

  Future<void> markAttended(String visitId) async {
    final firestore = _firestore;
    if (!firebaseReady || firestore == null) return;

    await firestore.collection('clinic_visits').doc(visitId).update({
      'status': 'attended',
    });
  }
}
