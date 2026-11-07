import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> register(String name, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user!.updateDisplayName(name);
    await _db.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'email': email,
      'role': AppConstants.roleStudent,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await cred.user!.sendEmailVerification();
  }

  Future<void> login(String email, String password) =>
    _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> logout() => _auth.signOut();

  Future<void> resendVerification() => _auth.currentUser!.sendEmailVerification();

  Future <void> reloadUser() async => _auth.currentUser?.reload();

  Future<UserModel?> fetchProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data()!, uid) : null;
  }
}