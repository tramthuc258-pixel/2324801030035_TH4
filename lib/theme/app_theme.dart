import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFFB42318);

  // ================= LIGHT THEME =================
  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF8F8FA),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,

        // Status bar Light Mode
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,

          // Giờ, WiFi, pin -> màu đen
          statusBarIconBrightness: Brightness.dark,

          // Dành cho iOS
          statusBarBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        indicatorColor: primaryColor.withValues(
          alpha: 0.12,
        ),
      ),
    );
  }

  // ================= DARK THEME =================
  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF101114),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,

        // Status bar Dark Mode
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,

          // Giờ, WiFi, pin -> màu trắng
          statusBarIconBrightness: Brightness.light,

          // Dành cho iOS
          statusBarBrightness: Brightness.dark,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1B1D21),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        indicatorColor: primaryColor.withValues(
          alpha: 0.25,
        ),
      ),
    );
  }
}