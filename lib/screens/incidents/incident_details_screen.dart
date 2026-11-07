import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../models/incident_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/status_timeline.dart';
import '../../core/utils/category_utils.dart';

class IncidentDetailsScreen extends StatelessWidget {
  final String incidentId;
  const IncidentDetailsScreen({super.key, required this.incidentId});

  Future<void> _confirmDelete(BuildContext context, Incident incident) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete report?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final provider = context.read<IncidentProvider>();
    final ok = await provider.deleteIncident(incident);
    if (!context.mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(provider.error ?? 'Delete failed')));
    }
  }

  Future<void> _changeStatus(BuildContext context, Incident incident, String status) async {
    if (incident.status == status) return;
    final provider = context.read<IncidentProvider>();
    final ok = await provider.updateStatus(incident.id, status);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Status updated to ${statusLabel(status)}' : (provider.error ?? 'Update failed')),
    ));
}

  @override
  Widget build(BuildContext context) {
    final incident = context.watch<IncidentProvider>().byId(incidentId);
    final auth = context.watch<AuthProvider>();

    if (incident == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox());
    }

    final canDelete = incident.reportedBy == auth.profile?.uid &&
        incident.status == AppConstants.statusSubmitted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Details'),
        actions: [
          if (canDelete)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context, incident),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(children: [
            Expanded(
              child: Text(incident.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            StatusBadge(status: incident.status),
          ]),
          const SizedBox(height: 12),
          _metaRow(Icons.place_outlined, incident.location),
          _metaRow(Icons.category_outlined, incident.category),
          _metaRow(Icons.calendar_today_outlined, 'Submitted on ${formatDateTime(incident.createdAt)}'),
          _metaRow(Icons.person_outline, 'Reported by ${incident.reporterName}'),
          const SizedBox(height: 24),
          _sectionTitle('Status Timeline'),
          StatusTimeline(incident: incident),

          if (auth.isStaff) ...[
            const SizedBox(height: 24),
            _sectionTitle('Update status (staff only)'),
            Wrap(
              spacing: 8,
              children: AppConstants.statuses
                .map((s) => ChoiceChip(
                  label: Text(statusLabel(s)),
                  selected: incident.status == s,
                  onSelected: (_) => _changeStatus(context, incident, s),
                ))
                .toList(),
            ),
          ],

          const SizedBox(height: 24),
          _sectionTitle('Description'),
          Text(incident.description),
          if (incident.imageUrl != null) ...[
            const SizedBox(height: 24),
            _sectionTitle('Attached Photo'),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                incident.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Widget _sectionTitle(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
);

Widget _metaRow(IconData icon, String text) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Row(children: [
    Icon(icon, size: 16, color: Colors.grey.shade600),
    const SizedBox(width: 8),
    Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade700))),
  ]),
);