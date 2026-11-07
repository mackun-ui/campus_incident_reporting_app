import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/category_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';
import '../../widgets/incident_card.dart';
import '../incidents/incident_details_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  Widget _chips({
    required List<String?> options,
    required String? selected,
    required String Function(String?) label,
    required void Function(String?) onSelected,
  }) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: options
          .map((o) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label(o)),
              selected: selected == o,
              onSelected: (_) => onSelected(o),
            ),
          ))
          .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();
    final isStaff = context.watch<AuthProvider>().isStaff;
    final items = provider.filtered;

    Widget list;
    if (provider.isLoading) {
      list = const Center(child: CircularProgressIndicator());
    } else if (provider.incidents.isEmpty) {
      list = const Center(child: Text('No reports yet'));
    } else if (items.isEmpty) {
      list = const Center(child: Text('No reports match your filters'));
    } else {
      list = ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        itemCount: items.length,
        itemBuilder: (_, i) => IncidentCard(
          incident: items[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IncidentDetailsScreen(incidentId: items[i].id)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(isStaff ? 'All Reports' : 'My Reports')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: provider.setQuery,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by title, description or location',
              ),
            ),
          ),
          _chips(
            options: [null, ...AppConstants.statuses],
            selected: provider.statusFilter,
            label: (o) => o == null ? 'All' : statusLabel(o),
            onSelected: provider.setStatusFilter,
          ),
          _chips(
            options: [null, ...AppConstants.categories],
            selected: provider.categoryFilter,
            label: (o) => o ?? 'All categories',
            onSelected: provider.setCategoryFilter,
          ),
          const SizedBox(height: 4),
          Expanded(child: list),
        ],
      ),
    );
  }
}