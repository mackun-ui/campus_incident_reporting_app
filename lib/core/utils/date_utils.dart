import 'package:intl/intl.dart';

String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return _ago(diff.inHours, 'hour');
  if (diff.inDays < 7) return _ago(diff.inDays, 'day');
  return DateFormat('MMM d, y').format(date);
}

String _ago(int n, String unit) => '$n $unit${n == 1 ? '' : 's'} ago';

String formatDateTime(DateTime d) => DateFormat("MMM d, y 'at' h:mm a").format(d);

String formatShort(DateTime d) => DateFormat('MMM d, h:mm a').format(d);