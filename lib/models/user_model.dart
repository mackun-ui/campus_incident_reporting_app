import '../core/constants/app_constants.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;

  UserModel({required this.uid, required this.name, required this.email, required this.role});

  bool get isStaff => role == AppConstants.roleStaff;

  factory UserModel.fromMap(Map<String, dynamic> m, String uid) => UserModel(
    uid: uid,
    name: m['name'] ?? '',
    email: m['email'] ?? '',
    role: m['role'] ?? AppConstants.roleStudent,
  );
}