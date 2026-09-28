import 'package:flutter/material.dart';

class AppColors {
  // Brand Islamic Colors - Rich Gold & Deep Spiritual Purple (from belloajetayo/myislam)
  // Primary Gold (hsl(38 92% 50%))
  static const Color primaryGold = Color(0xFFF59E0B);
  static const Color primaryGoldLight = Color(0xFFFBBF24);
  static const Color primaryGoldDark = Color(0xFFD97706);
  static const Color islamicGold = Color(0xFFF59E0B);
  static const Color islamicGoldLight = Color(0xFFFBBF24);
  static const Color islamicGoldDark = Color(0xFFD97706);

  // Secondary Deep Spiritual Purple (hsl(270 50% 45%)) & Indigo (from belloajetayo/myislam)
  static const Color secondaryPurple = Color(0xFF7938B0);
  static const Color secondaryPurpleLight = Color(0xFF9D62D2);
  static const Color islamicPurple = Color(0xFF7938B0);
  static const Color islamicPurpleDeep = Color(0xFF6D28D9);
  static const Color islamicPurpleDark = Color(0xFF581C87);
  static const Color islamicIndigo = Color(0xFF6366F1);
  static const Color islamicIndigoDeep = Color(0xFF4F46E5);

  // Accent Teal & Islamic Emerald
  static const Color accentTeal = Color(0xFF0D9488);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color islamicGreen = Color(0xFF10B981);
  static const Color islamicEmerald = Color(0xFF059669);
  static const Color islamicTeal = Color(0xFF0D9488);
  static const Color islamicRose = Color(0xFFF43F5E);
  static const Color islamicSky = Color(0xFF0EA5E9);
  static const Color islamicSkyLight = Color(0xFF38BDF8);

  // Light Mode Palette (from MobileLayout.tsx: bg-gradient-to-br from-indigo-50 via-blue-50 to-sky-100)
  static const Color lightBgStart = Color(0xFFEEF2FF); // indigo-50
  static const Color lightBgMid = Color(0xFFEFF6FF);   // blue-50
  static const Color lightBgEnd = Color(0xFFE0F2FE);   // sky-100
  static const Color lightCardBg = Colors.white;       // Pure white card
  static const Color lightSurface = Color(0xFFF8FAFC); // Subtle surface
  static const Color lightBorder = Color(0xFFE2E8F0);  // slate-200 border
  static const Color lightBorderAccent = Color(0xFFE0E7FF); // indigo-100
  static const Color lightTextPrimary = Color(0xFF1E1B4B); // indigo-950 deep navy
  static const Color lightTextSecondary = Color(0xFF64748B); // slate-500
  static const Color lightMuted = Color(0xFFF1F5F9);   // slate-100

  // Dark Mode Palette (from MobileLayout.tsx: linear-gradient(160deg, #0f0c29 0%, #1a1a4e 40%, #0f2027 100%))
  static const Color darkBgStart = Color(0xFF0F0C29);
  static const Color darkBgMid = Color(0xFF1A1A4E);
  static const Color darkBgEnd = Color(0xFF0F2027);
  static const Color darkCardBg = Color(0xFF16162A);
  static const Color darkSurface = Color(0xFF131326);
  static const Color darkBorder = Color(0xFF282548);
  static const Color darkBorderAccent = Color(0xFF3730A3);
  static const Color darkTextPrimary = Color(0xFFFAF7F2); // Warm light cream
  static const Color darkTextSecondary = Color(0xFF94A3B8); // slate-400
  static const Color darkMuted = Color(0xFF1F1D38);

  // Signature Web Gradients (from src/index.css & MobileLayout.tsx in belloajetayo/myislam)
  // --gradient-primary: linear-gradient(135deg, hsl(38 92% 55%) 0%, hsl(28 90% 48%) 50%, hsl(270 50% 50%) 100%)
  static const LinearGradient primaryBrandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B), // Rich Gold
      Color(0xFFEA580C), // Warm Amber / Sunset
      Color(0xFF7938B0), // Deep Spiritual Purple
    ],
  );

  static const LinearGradient purpleGoldShiningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFBBF24), // Shining Gold
      Color(0xFFF59E0B), // Warm Amber
      Color(0xFFA855F7), // Royal Violet
      Color(0xFF7E22CE), // Deep Purple
    ],
  );

  // Active Pill & Nav Button Gradient (from BottomNavigation.tsx: bg-gradient-to-br from-indigo-500 to-purple-600)
  static const LinearGradient activeNavPillGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo 500
      Color(0xFF7C3AED), // Purple 600
    ],
  );

  // Light Prayer Hero Gradient (from PrayerTopBar.tsx: from-indigo-500 via-blue-500 to-sky-400)
  static const LinearGradient prayerHeroLightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo 500
      Color(0xFF3B82F6), // Blue 500
      Color(0xFF38BDF8), // Sky 400
    ],
  );

  // Dark Prayer Hero Gradient (from PrayerTopBar.tsx: from-indigo-950 via-blue-900 to-slate-900)
  static const LinearGradient prayerHeroDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1B4B), // Indigo 950
      Color(0xFF1E3A5F), // Deep Oceanic Navy
      Color(0xFF0F2027), // Midnight Slate
    ],
  );

  static const LinearGradient purpleGoldHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1B4B),
      Color(0xFF2E1065),
      Color(0xFF172554),
    ],
  );

  // Astra 3D Palette (Sky Blue, Shining Gold, Royal Purple Gradients)
  static const Color astraSky = Color(0xFF0EA5E9);
  static const Color astraSkyLight = Color(0xFF38BDF8);
  static const Color astraSkyCyan = Color(0xFF06B6D4);
  static const Color astraSkySoft = Color(0xFFE0F2FE);

  static const Color astraGold = Color(0xFFF59E0B);
  static const Color astraGoldLight = Color(0xFFFDE047);
  static const Color astraGoldShine = Color(0xFFFFFBEB);

  static const Color astraPurple = Color(0xFF8B5CF6);
  static const Color astraPurpleDeep = Color(0xFF6D28D9);
  static const Color astraPurpleCosmic = Color(0xFF2E1065);

  // Astra 3D Fusion Gradients (Friendly & Radiant)
  static const LinearGradient astraTrilateralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF38BDF8), // Sky Blue Light
      Color(0xFF0EA5E9), // Sky Blue
      Color(0xFFFBBF24), // Shining Gold
      Color(0xFFA855F7), // Radiant Violet
      Color(0xFF7E22CE), // Cosmic Purple
    ],
  );

  static const LinearGradient astraFriendlyGlowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF7DD3FC), // Gentle Sky Blue
      Color(0xFFFDE047), // Friendly Gold
      Color(0xFFC084FC), // Soft Lavender
    ],
  );

  static const RadialGradient astraAtmosphereGradient = RadialGradient(
    colors: [
      Color(0x6638BDF8), // Glowing Sky Blue
      Color(0x44FBBF24), // Shimmering Gold
      Color(0x33A855F7), // Soft Purple
      Colors.transparent,
    ],
    stops: [0.0, 0.45, 0.75, 1.0],
  );

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
