import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';

class StatusEntry {
  final String status;
  final DateTime at;
  final String by;

  StatusEntry({required this.status, required this.at, required this.by});

  factory StatusEntry.fromMap(Map<String, dynamic> m) => StatusEntry(
        status: m['status'] ?? AppConstants.statusSubmitted,
        at: (m['at'] as Timestamp?)?.toDate() ?? DateTime.now(),
        by: m['by'] ?? '',
      );
}

class Incident {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final String? imageUrl;
  final String status;
  final String reportedBy;
  final String reporterName;
  final DateTime createdAt;
  final List<StatusEntry> history;

  Incident({
    this.id = '',
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.imageUrl,
    this.status = AppConstants.statusSubmitted,
    required this.reportedBy,
    required this.reporterName,
    DateTime? createdAt,
    this.history = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  /// Used when creating a new document.
  Map<String, dynamic> toNewMap() => {
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'imageUrl': imageUrl,
        'status': AppConstants.statusSubmitted,
        'reportedBy': reportedBy,
        'reporterName': reporterName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'history': [
          {'status': AppConstants.statusSubmitted, 'at': Timestamp.now(), 'by': reporterName},
        ],
      };

  factory Incident.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    return Incident(
      id: doc.id,
      title: m['title'] ?? '',
      description: m['description'] ?? '',
      category: m['category'] ?? '',
      location: m['location'] ?? '',
      imageUrl: m['imageUrl'],
      status: m['status'] ?? AppConstants.statusSubmitted,
      reportedBy: m['reportedBy'] ?? '',
      reporterName: m['reporterName'] ?? '',
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
      history: ((m['history'] as List?) ?? [])
          .map((e) => StatusEntry.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}