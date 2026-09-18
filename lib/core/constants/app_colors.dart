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

  // Muslim Pro / Pocket Emerald Palette
  static const Color emeraldDeep = Color(0xFF064E3B);
  static const Color emeraldForest = Color(0xFF065F46);
  static const Color emeraldPrimary = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFF10B981);
  static const Color emeraldSoft = Color(0xFFD1FAE5);

  // Royal Gold Palette
  static const Color goldRoyal = Color(0xFFD97706);
  static const Color goldWarm = Color(0xFFF59E0B);
  static const Color goldLight = Color(0xFFFDE68A);
  static const Color goldOchre = Color(0xFFB45309);

  // Authentic Quran Mushaf Paper Palettes
  static const Color mushafMadaniBg = Color(0xFFFAF6EB);
  static const Color mushafMadaniBorder = Color(0xFFC5A869);
  static const Color mushafMadaniText = Color(0xFF1C1917);

  static const Color mushafAntiqueBg = Color(0xFFF4EEDD);
  static const Color mushafAntiqueBorder = Color(0xFF9E8148);
  static const Color mushafAntiqueText = Color(0xFF1E1B18);

  static const Color mushafDarkBg = Color(0xFF0F172A);
  static const Color mushafDarkBorder = Color(0xFFB4975A);
  static const Color mushafDarkText = Color(0xFFF8FAFC);

  static const Color mushafEmeraldBg = Color(0xFF062E23);
  static const Color mushafEmeraldBorder = Color(0xFFD4AF37);
  static const Color mushafEmeraldText = Color(0xFFECFDF5);

  // Dynamic Prayer Time-of-Day Gradients
  static const LinearGradient fajrDawnGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4C1D95)],
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEA580C), Color(0xFFF59E0B), Color(0xFFFBBF24)],
  );

  static const LinearGradient dhuhrAzureGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0284C7), Color(0xFF0EA5E9), Color(0xFF38BDF8)],
  );

  static const LinearGradient asrAmberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD97706), Color(0xFFF59E0B), Color(0xFFFBBF24)],
  );

  static const LinearGradient maghribDuskGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF831843), Color(0xFF9D174D), Color(0xFFBE185D)],
  );

  static const LinearGradient ishaNightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF090D16), Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const LinearGradient emeraldHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF064E3B), Color(0xFF065F46), Color(0xFF059669)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static const LinearGradient quranGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF0D9488)],
  );

  static const LinearGradient salatGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0284C7), Color(0xFF2563EB)],
  );

  static const LinearGradient zakatGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD97706), Color(0xFFEA580C)],
  );

  static const LinearGradient sawmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
  );

  static const LinearGradient hajjGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
  );

  static const LinearGradient tasbihGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF10B981), Color(0xFF34D399)],
  );

  static const LinearGradient heroPrayerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF047857), Color(0xFF059669), Color(0xFF0D9488)],
  );

  static const LinearGradient heroPrayerDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF062E23), Color(0xFF0F172A), Color(0xFF111827)],
  );
}
