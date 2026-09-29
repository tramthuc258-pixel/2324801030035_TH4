import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/category_screen.dart';
import 'screens/home_screen.dart';
import 'screens/latest_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _changeTheme(bool isDarkMode) {
    setState(() {
      _themeMode =
          isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        _themeMode == ThemeMode.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VNews',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,

      // Quản lý màu status bar cho toàn bộ ứng dụng
      builder: (context, child) {
        final bool isDark =
            Theme.of(context).brightness ==
                Brightness.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,

            // Light -> icon đen
            // Dark  -> icon trắng
            statusBarIconBrightness:
                isDark
                    ? Brightness.light
                    : Brightness.dark,

            statusBarBrightness:
                isDark
                    ? Brightness.dark
                    : Brightness.light,

            systemNavigationBarColor:
                isDark
                    ? const Color(0xFF101114)
                    : Colors.white,

            systemNavigationBarIconBrightness:
                isDark
                    ? Brightness.light
                    : Brightness.dark,
          ),
          child: child!,
        );
      },

      home: MainNavigation(
        isDarkMode: isDarkMode,
        onThemeChanged: _changeTheme,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainNavigation({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const CategoryScreen(),
      const LatestScreen(),

      SettingsScreen(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      // Giữ trạng thái khi chuyển giữa các tab
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Tin tổng hợp',
          ),

          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Chủ đề',
          ),

          NavigationDestination(
            icon: Icon(Icons.bolt_outlined),
            selectedIcon: Icon(Icons.bolt_rounded),
            label: 'Tin mới nhất',
          ),

          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}