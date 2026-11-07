import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/category_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';
import '../report/report_incident_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final incidents = context.watch<IncidentProvider>();

    Widget body;
    if (incidents.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (incidents.incidents.isEmpty) {
      body = const Center(child: Text('No reports yet'));
    } else {
      body = ListView.separated(
        itemCount: incidents.incidents.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final item = incidents.incidents[i];
          return ListTile(
            leading: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(item.imageUrl!, width: 48, height: 48, fit: BoxFit.cover),
                  )
                : Icon(categoryIcon(item.category)),
            title: Text(item.title),
            subtitle: Text('${item.location} • ${statusLabel(item.status)}'),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${auth.profile?.name ?? ''}'),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: auth.logout)],
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}