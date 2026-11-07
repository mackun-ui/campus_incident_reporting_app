import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incident_model.dart';

class IncidentService {
  final _col = FirebaseFirestore.instance.collection('incidents');

  /// staff see every report and students only see their own.
  Stream<List<Incident>> watch(String uid, bool isStaff) {
    final query = isStaff
        ? _col.orderBy('createdAt', descending: true)
        : _col.where('reportedBy', isEqualTo: uid);
    return query.snapshots().map((snap) {
      final list = snap.docs.map(Incident.fromDoc).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Future<void> create(Incident incident) => _col.add(incident.toNewMap());

  Future<Incident?> getById(String id) async {
    final doc = await _col.doc(id).get();
    return doc.exists ? Incident.fromDoc(doc) : null;
  }

  Future<void> update(String id, Map<String, dynamic> data) =>
      _col.doc(id).update({...data, 'updatedAt': FieldValue.serverTimestamp()});

  Future<void> updateStatus(String id, String status, String staffName) =>
      _col.doc(id).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        'history': FieldValue.arrayUnion([
          {'status': status, 'at': Timestamp.now(), 'by': staffName},
        ]),
      });

  Future<void> delete(String id) => _col.doc(id).delete();
}