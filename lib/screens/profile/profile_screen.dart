import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final incidents = context.watch<IncidentProvider>();
    final profile = auth.profile;
    final name = profile?.name ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primary,
              child: Text(name.isEmpty ? '?' : name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 32, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
          Center(child: Text(profile?.email ?? '', style: TextStyle(color: Colors.grey.shade600))),
          const SizedBox(height: 8),
          Center(child: Chip(label: Text(auth.isStaff ? 'Staff' : 'Student'))),
          const SizedBox(height: 24),
          Row(children: [
            _Stat(count: incidents.total, label: 'Total'),
            _Stat(count: incidents.countByStatus(AppConstants.statusInProgress), label: 'In Progress'),
            _Stat(count: incidents.countByStatus(AppConstants.statusResolved), label: 'Resolved'),
          ]),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: auth.logout,
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final int count;
  final String label;
  const _Stat({required this.count, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text('$count', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ]),
      );
}