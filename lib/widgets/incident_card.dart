import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/category_utils.dart';
import '../core/utils/date_utils.dart';
import '../models/incident_model.dart';
import 'status_badge.dart';

class IncidentCard extends StatelessWidget {
  final Incident incident;
  final VoidCallback onTap;
  const IncidentCard({super.key, required this.incident, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final grey = Colors.grey.shade600;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _Thumb(incident: incident),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(incident.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(incident.location, style: TextStyle(color: grey, fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Icon(Icons.access_time, size: 14, color: grey),
                      const SizedBox(width: 4),
                      Text(timeAgo(incident.createdAt), style: TextStyle(color: grey, fontSize: 12)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(status: incident.status),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final Incident incident;
  const _Thumb({required this.incident});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 56,
      height: 56,
      color: AppTheme.primary.withAlpha(30),
      child: Icon(categoryIcon(incident.category), color: AppTheme.primary),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: incident.imageUrl == null
          ? placeholder
          : Image.network(
              incident.imageUrl!,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}