import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Helper to convert standard digits into Eastern Arabic digits (١، ٢، ٣...)
String toArabicDigits(int number) {
  const englishToArabic = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };
  return number.toString().split('').map((ch) => englishToArabic[ch] ?? ch).join();
}

/// Authentic Madani Mushaf Page Border with double gilded borders & ornate corners
class MushafPageBorder extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color backgroundColor;
  final String? surahTitle;
  final String? juzTitle;
  final int? pageNumber;

  const MushafPageBorder({
    super.key,
    required this.child,
    this.borderColor = AppColors.mushafMadaniBorder,
    this.backgroundColor = AppColors.mushafMadaniBg,
    this.surahTitle,
    this.juzTitle,
    this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Outer ornamental border
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor.withOpacity(0.85), width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Inner ornamental border
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor.withOpacity(0.5), width: 0.8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Four corner rosettes (Rub el Hizb ۞)
          Positioned(
            top: 5,
            left: 5,
            child: _buildCornerRosette(),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: _buildCornerRosette(),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: _buildCornerRosette(),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: _buildCornerRosette(),
          ),

          // Main content inside the frame
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              children: [
                // Top running header like the printed Mushaf
                if (surahTitle != null || juzTitle != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          juzTitle ?? "",
                          style: GoogleFonts.amiri(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: borderColor.withOpacity(0.9),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "۞",
                            style: TextStyle(color: borderColor, fontSize: 11),
                          ),
                        ),
                        Text(
                          surahTitle ?? "",
                          style: GoogleFonts.amiri(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: borderColor.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Actual child (Surah content)
                Expanded(child: child),

                // Bottom page number
                if (pageNumber != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      toArabicDigits(pageNumber!),
                      style: GoogleFonts.amiri(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: borderColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerRosette() {
    return Container(
      width: 16,
      height: 16,
      alignment: Alignment.center,
      child: Text(
        "۞",
        style: TextStyle(
          fontSize: 12,
          color: borderColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Traditional Surah Title Cartouche (Decorative header box at the start of a Surah)
class SurahCartoucheHeader extends StatelessWidget {
  final String surahNameArabic;
  final String revelationType;
  final int numberOfAyahs;
  final Color borderColor;
  final Color textColor;
  final bool isDark;

  const SurahCartoucheHeader({
    super.key,
    required this.surahNameArabic,
    required this.revelationType,
    required this.numberOfAyahs,
    this.borderColor = AppColors.mushafMadaniBorder,
    this.textColor = AppColors.mushafMadaniText,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final revArabic = revelationType.toLowerCase().contains("meccan") ? "مَكِّيَّةٌ" : "مَدَنِيَّةٌ";
    final ayahArabic = "آيَاتُهَا ${toArabicDigits(numberOfAyahs)}";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFF9F3DF), const Color(0xFFEFE2BC)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative inner outline
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor.withOpacity(0.5), width: 0.8),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Right badge (Revelation place)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    revArabic,
                    style: GoogleFonts.amiri(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : const Color(0xFF573E13),
                    ),
                  ),
                ),

                // Center Title (سُورَة ...)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "سُورَةُ $surahNameArabic",
                      style: GoogleFonts.amiriQuran(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF422E0B),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),

                // Left badge (Ayah count)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    ayahArabic,
                    style: GoogleFonts.amiri(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : const Color(0xFF573E13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Traditional Bismillah Calligraphic Header
class BismillahBanner extends StatelessWidget {
  final Color textColor;
  final Color borderColor;

  const BismillahBanner({
    super.key,
    this.textColor = const Color(0xFF382910),
    this.borderColor = AppColors.mushafMadaniBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("— ۞ ", style: TextStyle(color: borderColor.withOpacity(0.7), fontSize: 13)),
              Text(
                "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                textAlign: TextAlign.center,
                style: GoogleFonts.amiriQuran(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  height: 1.6,
                ),
              ),
              Text(" ۞ —", style: TextStyle(color: borderColor.withOpacity(0.7), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: 120,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  borderColor.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ornate Quranic Ayah End Rosette Marker
class AyahRosetteMarker extends StatelessWidget {
  final int verseNumber;
  final Color color;
  final double size;

  const AyahRosetteMarker({
    super.key,
    required this.verseNumber,
    this.color = AppColors.goldRoyal,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.8), width: 1.5),
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.18),
            color.withOpacity(0.04),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        toArabicDigits(verseNumber),
        style: GoogleFonts.amiri(
          fontSize: size * 0.44,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
