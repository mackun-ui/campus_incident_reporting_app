import 'package:flutter/material.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Facilities':
      return Icons.apartment;
    case 'Water':
      return Icons.water_drop_outlined;
    case 'Electricity':
      return Icons.bolt;
    case 'Safety':
      return Icons.shield_outlined;
    case 'Sanitation':
      return Icons.delete_outline;
    default:
      return Icons.report_problem_outlined;
  }
}

String statusLabel(String status) {
  switch (status) {
    case 'in_progress':
      return 'In Progress';
    case 'resolved':
      return 'Resolved';
    default:
      return 'Submitted';
  }
}