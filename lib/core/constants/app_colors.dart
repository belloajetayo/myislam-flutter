import 'package:flutter/material.dart';

class AppColors {
  // Brand Islamic Colors - Purple & Gold Signature (myislam2.vercel.app)
  static const Color islamicGold = Color(0xFFF59E0B);
  static const Color islamicGoldLight = Color(0xFFFBBF24);
  static const Color islamicGoldDark = Color(0xFFD97706);
  static const Color islamicPurple = Color(0xFF8B5CF6);
  static const Color islamicPurpleDeep = Color(0xFF7E22CE);
  static const Color islamicPurpleDark = Color(0xFF6D28D9);
  static const Color islamicGreen = Color(0xFF10B981);
  static const Color islamicTeal = Color(0xFF0D9488);
  static const Color islamicIndigo = Color(0xFF6366F1);
  static const Color islamicRose = Color(0xFFF43F5E);
  static const Color islamicSky = Color(0xFF0EA5E9);

  // Dark Mode Palette (myislam2 deep violet-black: hsl(240 15% 6%))
  static const Color darkBgStart = Color(0xFF0C0A17);
  static const Color darkBgMid = Color(0xFF15102A);
  static const Color darkBgEnd = Color(0xFF0C0A17);
  static const Color darkCardBg = Color(0xFF18142E);
  static const Color darkSurface = Color(0xFF18142E);
  static const Color darkBorder = Color(0xFF2C254C);
  static const Color darkTextPrimary = Color(0xFFFAF7F2);
  static const Color darkTextSecondary = Color(0xFF9E97B8);

  // Light Mode Palette (Sea Blue Theme)
  static const Color lightBgStart = Color(0xFFE8F4FD); // Gentle Sea Blue
  static const Color lightBgMid = Color(0xFFDCF0FB);   // Soft Coastal Sea Blue
  static const Color lightBgEnd = Color(0xFFCEE9FA);   // Radiant Azure Sea Blue
  static const Color lightCardBg = Colors.white;       // Crisp white cards pop on sea blue
  static const Color lightSurface = Color(0xFFF0F7FD); // Very subtle sea tint surface
  static const Color lightBorder = Color(0xFFBAE0F8);  // Sea Blue border
  static const Color lightTextPrimary = Color(0xFF0C1E33); // Deep ocean navy
  static const Color lightTextSecondary = Color(0xFF3B566E); // Sea slate navy

  // Shining Purple-Gold Brand Gradient (Signature from myislam2.vercel.app)
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

  static const LinearGradient purpleGoldHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF241544),
      Color(0xFF381F66),
      Color(0xFF1C0E36),
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
