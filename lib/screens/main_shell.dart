import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'report/report_incident_screen.dart';
import 'reports/reports_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onSeeAll: () => _goTo(1)),
          const ReportsScreen(),
          const ProfileScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_outlined, 'Home', 0),
            _navItem(Icons.description_outlined, 'Reports', 1),
            const SizedBox(width: 48),
            _navItem(Icons.person_outline, 'Profile', 2),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final color = _index == index ? AppTheme.primary : Colors.grey;
    return InkWell(
      onTap: () => _goTo(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            Text(label, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}