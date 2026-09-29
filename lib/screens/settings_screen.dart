import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'GIAO DIỆN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: SwitchListTile(
              value: isDarkMode,
              onChanged: onThemeChanged,
              secondary: Icon(
                isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
              ),
              title: const Text(
                'Chế độ tối',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                isDarkMode
                    ? 'Đang sử dụng giao diện tối'
                    : 'Đang sử dụng giao diện sáng',
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'THÔNG TIN ỨNG DỤNG',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                _InfoTile(
                  icon: Icons.person_outline,
                  title: 'Họ và tên',
                  value: 'Đinh Thị Thùy Trâm',
                ),

                const Divider(height: 1),

                _InfoTile(
                  icon: Icons.badge_outlined,
                  title: 'MSSV',
                  value: '2324801030035',
                ),

                const Divider(height: 1),

                _InfoTile(
                  icon: Icons.school_outlined,
                  title: 'Lớp',
                  value: 'D23KTPM01',
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          Center(
            child: Text(
              'VNews • Ứng dụng đọc báo Online',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}