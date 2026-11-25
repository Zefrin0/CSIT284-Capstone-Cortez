import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../data/demo_visits.dart';
import '../firebase_options.dart'; 
import 'clinic_visit.dart';

/// Single source of truth for clinic visits.
///
/// Uses Cloud Firestore when Firebase is configured, otherwise an in-memory
/// demo store. Both modes expose the same CRUD API and the same stream, so
/// the UI never has to care which one is active.
class ClinicRepository {
  static const _collectionName = 'clinic_visits';

  bool firebaseReady = false;
  FirebaseFirestore? _firestore;

  final List<ClinicVisit> _demoVisits = buildDemoVisits();
  final StreamController<List<ClinicVisit>> _demoController =
      StreamController<List<ClinicVisit>>.broadcast();

  Future<void> initialize() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _firestore = FirebaseFirestore.instance;
    firebaseReady = true;
  } catch (_) {
    firebaseReady = false;
  }
}
  CollectionReference<Map<String, dynamic>>? get _collection =>
      firebaseReady ? _firestore?.collection(_collectionName) : null;

  // ---------------------------------------------------------------- READ

  Stream<List<ClinicVisit>> visitStream() async* {
    final collection = _collection;
    if (collection != null) {
      yield* collection
          .orderBy('visitedAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map(_fromDoc).toList());
    } else {
      yield _sortedDemo();
      yield* _demoController.stream;
    }
  }

  ClinicVisit _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final timestamp = data['visitedAt'] as Timestamp?;
    return ClinicVisit(
      id: doc.id,
      studentName: data['studentName'] as String? ?? '',
      studentId: data['studentId'] as String? ?? '',
      symptom: data['symptom'] as String? ?? '',
      // null while a server timestamp write is still pending locally
      visitedAt: timestamp?.toDate() ?? DateTime.now(),
      status: data['status'] == 'attended'
          ? VisitStatus.attended
          : VisitStatus.waiting,
    );
  }

  // -------------------------------------------------------------- CREATE

  Future<void> addVisit({
    required String studentName,
    required String studentId,
    required String symptom,
  }) async {
    final collection = _collection;
    if (collection != null) {
      await collection.add({
        'studentName': studentName,
        'studentId': studentId,
        'symptom': symptom,
        'visitedAt': FieldValue.serverTimestamp(),
        'status': 'waiting',
      });
      return;
    }

    _demoVisits.add(
      ClinicVisit(
        id: 'visit-${DateTime.now().microsecondsSinceEpoch}',
        studentName: studentName,
        studentId: studentId,
        symptom: symptom,
        visitedAt: DateTime.now(),
      ),
    );
    _emitDemo();
  }

  // -------------------------------------------------------------- UPDATE

  Future<void> updateVisit(
    String visitId, {
    required String studentName,
    required String studentId,
    required String symptom,
  }) async {
    final collection = _collection;
    if (collection != null) {
      await collection.doc(visitId).update({
        'studentName': studentName,
        'studentId': studentId,
        'symptom': symptom,
      });
      return;
    }

    _replaceDemo(
      visitId,
      (visit) => visit.copyWith(
        studentName: studentName,
        studentId: studentId,
        symptom: symptom,
      ),
    );
  }

  Future<void> markAttended(String visitId) async {
    final collection = _collection;
    if (collection != null) {
      await collection.doc(visitId).update({'status': 'attended'});
      return;
    }

    _replaceDemo(
      visitId,
      (visit) => visit.copyWith(status: VisitStatus.attended),
    );
  }

  // -------------------------------------------------------------- DELETE

  Future<void> deleteVisit(String visitId) async {
    final collection = _collection;
    if (collection != null) {
      await collection.doc(visitId).delete();
      return;
    }

    _demoVisits.removeWhere((visit) => visit.id == visitId);
    _emitDemo();
  }

  // ---------------------------------------------------------- demo helpers

  void _replaceDemo(String id, ClinicVisit Function(ClinicVisit) change) {
    final index = _demoVisits.indexWhere((visit) => visit.id == id);
    if (index == -1) return;
    _demoVisits[index] = change(_demoVisits[index]);
    _emitDemo();
  }

  List<ClinicVisit> _sortedDemo() {
    final copy = List<ClinicVisit>.of(_demoVisits);
    copy.sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
    return copy;
  }

  void _emitDemo() => _demoController.add(_sortedDemo());

  void dispose() => _demoController.close();
}
