import 'package:flutter/material.dart';

class AppColors {
  // Brand Islamic Colors
  static const Color islamicGold = Color(0xFFF59E0B);
  static const Color islamicGoldDark = Color(0xFFD97706);
  static const Color islamicGreen = Color(0xFF10B981);
  static const Color islamicTeal = Color(0xFF0D9488);
  static const Color islamicIndigo = Color(0xFF6366F1);
  static const Color islamicPurple = Color(0xFF8B5CF6);
  static const Color islamicRose = Color(0xFFF43F5E);
  static const Color islamicSky = Color(0xFF0EA5E9);

  // Dark Mode Palette
  static const Color darkBgStart = Color(0xFF0F0C29);
  static const Color darkBgMid = Color(0xFF1A1A4E);
  static const Color darkBgEnd = Color(0xFF0F2027);
  static const Color darkCardBg = Color(0x1AFFFFFF);
  static const Color darkBorder = Color(0x336366F1);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Light Mode Palette
  static const Color lightBgStart = Color(0xFFEEF2FF);
  static const Color lightBgMid = Color(0xFFF0F9FF);
  static const Color lightBgEnd = Color(0xFFF8FAFC);
  static const Color lightCardBg = Colors.white;
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Gradients
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBgStart, darkBgMid, darkBgEnd],
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBgStart, lightBgMid, lightBgEnd],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static const LinearGradient quranGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF0D9488)],
  );

  static const LinearGradient salatGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
  );

  static const LinearGradient zakatGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
  );

  static const LinearGradient sawmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
  );

  static const LinearGradient hajjGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
  );

  static const LinearGradient heroPrayerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF3B82F6), Color(0xFF38BDF8)],
  );

  static const LinearGradient heroPrayerDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1B4B), Color(0xFF1E3A5F), Color(0xFF0F2027)],
  );
}
