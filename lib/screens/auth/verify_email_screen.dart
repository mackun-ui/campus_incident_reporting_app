import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 72),
            const SizedBox(height: 16),
            Text('Verify your email', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('We sent a link to your ALU email. Open it, then come back.',
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(onPressed: auth.checkVerified, child: const Text("I've verified")),
            TextButton(
              onPressed: () async {
                final ok = await auth.resendVerification();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(ok ? 'Email sent' : (auth.error ?? 'Could not send'))));
                }
              },
              child: const Text('Resend email'),
            ),
            TextButton(onPressed: auth.logout, child: const Text('Log out')),
          ],
        ),
      ),
    );
  }
}