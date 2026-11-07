import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/category_utils.dart';
import '../core/utils/date_utils.dart';
import '../models/incident_model.dart';

class StatusTimeline extends StatelessWidget {
  final Incident incident;
  const StatusTimeline({super.key, required this.incident});

  DateTime? _dateFor(String status) {
    for (final e in incident.history.reversed) {
      if (e.status == status) return e.at;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final statuses = AppConstants.statuses;
    final reached = statuses.indexOf(incident.status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(statuses.length, (i) {
        final status = statuses[i];
        final done = i <= reached;
        final color = done ? statusColor(status) : Colors.grey.shade400;
        final date = _dateFor(status);
        final lineOn = Colors.grey.shade300;

        return Expanded(
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: Container(
                    height: 2,
                    color: i == 0 ? Colors.transparent : (done ? color : lineOn),
                  ),
                ),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: color,
                  child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: i == statuses.length - 1
                        ? Colors.transparent
                        : (i < reached ? color : lineOn),
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              Text(statusLabel(status),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: done ? FontWeight.w700 : FontWeight.normal)),
              if (date != null)
                Text(formatShort(date),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        );
      }),
    );
  }
}