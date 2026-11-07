import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  late final StreamSubscription<User?> _sub;

  User? _firebaseUser;
  UserModel? _profile;
  bool _initializing = true;
  bool _loading = false;
  String? _error;

  AuthProvider() {
    _sub = _service.authChanges.listen(_onAuthChanged);
  }

  bool get initializing => _initializing;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _firebaseUser != null;
  bool get isVerified => _firebaseUser?.emailVerified ?? false;
  UserModel? get profile => _profile;
  bool get isStaff => _profile?.isStaff ?? false;

  Future<void> _onAuthChanged(User? user) async {
    _firebaseUser = user;
    _profile = user == null ? null : await _service.fetchProfile(user.uid);
    _initializing = false;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Authentication error';
      return false;
    } catch (e) {
      _error = 'Something went wrong. Try again.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) =>
    _run(() async {
      await _service.register(name, email, password);
      _profile = await _service.fetchProfile(_firebaseUser!.uid);
    });
  
  Future <bool> login(String email, String password) =>
    _run(() => _service.login(email, password));
  
  Future<void> logout() => _service.logout();

  Future<bool> resendVerification() => _run(_service.resendVerification);

  Future<void> checkVerified() async {
    await _service.reloadUser();
    _firebaseUser = _service.currentUser;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}