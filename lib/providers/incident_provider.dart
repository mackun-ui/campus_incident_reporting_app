import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/incident_model.dart';
import '../models/user_model.dart';
import '../services/cloudinary_service.dart';
import '../services/incident_service.dart';

class IncidentProvider extends ChangeNotifier {
  final _service = IncidentService();
  final _cloudinary = CloudinaryService();

  StreamSubscription<List<Incident>>? _sub;
  UserModel? _user;
  List<Incident> _incidents = [];
  bool _loading = false;
  bool _submitting = false;
  String? _error;

  List<Incident> get incidents => _incidents;
  bool get isLoading => _loading;
  bool get isSubmitting => _submitting;
  String? get error => _error;

  // called by the ProxyProvider whenever the logged-in user changes.
  void bindUser(UserModel? user) {
    if (user?.uid == _user?.uid && user?.role == _user?.role) return;
    _user = user;
    _sub?.cancel();
    _incidents = [];
    if (user == null) {
      _loading = false;
      return;
    }
    _loading = true;
    _sub = _service.watch(user.uid, user.isStaff).listen(
      (list) {
        _incidents = list;
        _loading = false;
        _error = null;
        notifyListeners();
      },
      onError: (_) {
        _error = 'Could not load reports';
        _loading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> submit({
    required String title,
    required String description,
    required String category,
    required String location,
    File? image,
  }) async {
    final user = _user;
    if (user == null) return false;
    _submitting = true;
    _error = null;
    notifyListeners();
    try {
      final url = image != null ? await _cloudinary.uploadImage(image) : null;
      await _service.create(Incident(
        title: title,
        description: description,
        category: category,
        location: location,
        imageUrl: url,
        reportedBy: user.uid,
        reporterName: user.name,
      ));
      return true;
    } catch (_) {
      _error = 'Could not submit report. Check your connection and try again.';
      return false;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}