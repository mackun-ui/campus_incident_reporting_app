import '../constants/app_constants.dart';

class Validators {
  static String? required(String? v, String label) =>
    (v == null || v.trim().isEmpty) ? '$label is required' : null;
  
  static String? aluEmail(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Email is required';
    }

    final email = v.trim().toLowerCase();
    final ok = AppConstants.allowedEmailDomains.any((d) => email.endsWith('@$d'));
    return ok ? null : 'Use your ALU email address';
  }

  static String? password(String? v) =>
    (v == null || v.length < 6) ? 'At least 6 characters' : null;
}