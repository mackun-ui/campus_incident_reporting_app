import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';
import '../../widgets/incident_card.dart';
import '../incidents/incident_details_screen.dart';
import '../report/report_incident_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSeeAll;
  const HomeScreen({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final incidents = context.watch<IncidentProvider>();
    final name = auth.profile?.name ?? '';
    final firstName = name.split(' ').first;
    final recent = incidents.incidents.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, $firstName <3',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                      auth.isStaff
                          ? 'Review reports and update their status.'
                          : 'Help make our campus safer.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: AppTheme.primary,
                child: Text(firstName.isEmpty ? '?' : firstName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white)),
              ),
            ]),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFF5B2EE0)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('See an issue\non campus?',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text('Report it and help improve our learning environment.',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.white, foregroundColor: AppTheme.primary),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
                    ),
                    icon: const Icon(Icons.add_circle),
                    label: const Text('Report an Issue'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Report Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(children: [
              _SummaryTile(
                  icon: Icons.description_outlined,
                  color: AppTheme.primary,
                  count: incidents.total,
                  label: auth.isStaff ? 'All Reports' : 'My Reports'),
              const SizedBox(width: 8),
              _SummaryTile(
                  icon: Icons.schedule,
                  color: Colors.blue,
                  count: incidents.countByStatus(AppConstants.statusInProgress),
                  label: 'In Progress'),
              const SizedBox(width: 8),
              _SummaryTile(
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                  count: incidents.countByStatus(AppConstants.statusResolved),
                  label: 'Resolved'),
              const SizedBox(width: 8),
              _SummaryTile(
                  icon: Icons.error_outline,
                  color: Colors.orange,
                  count: incidents.countByStatus(AppConstants.statusSubmitted),
                  label: 'Submitted'),
            ]),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Reports',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                TextButton(onPressed: onSeeAll, child: const Text('See all')),
              ],
            ),
            const SizedBox(height: 8),
            if (recent.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No reports yet')),
              )
            else
              ...recent.map((i) => IncidentCard(
                    incident: i,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => IncidentDetailsScreen(incidentId: i.id)),
                    ),
                  )),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final String label;
  const _SummaryTile({
    required this.icon,
    required this.color,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(fontSize: 11)),
        ]),
      ),
    );
  }
}