import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QuickShortcuts extends StatelessWidget {
  final Function(String routeName) onNavigate;

  const QuickShortcuts({super.key, required this.onNavigate});

  // 6 Primary Pastel Squircle Cards (Inspired by Image 2 & Image 5)
  static const List<Map<String, dynamic>> _primaryTools = [
    {
      "label": "Holy Quran",
      "arabic": "القرآن الكريم",
      "subtitle": "114 Surahs • Audio",
      "icon": Icons.menu_book_rounded,
      "color": Color(0xFF059669),
      "gradient": [Color(0xFF10B981), Color(0xFF0D9488)],
      "pastelBgLight": Color(0xFFECFDF5),
      "pastelBgDark": Color(0xFF063326),
      "route": "quran",
      "badge": "Mushaf",
    },
    {
      "label": "Prayer Times",
      "arabic": "مواقيت الصلاة",
      "subtitle": "Adhan & Countdown",
      "icon": Icons.access_time_filled_rounded,
      "color": Color(0xFF3B82F6),
      "gradient": [Color(0xFF3B82F6), Color(0xFF6366F1)],
      "pastelBgLight": Color(0xFFF0F9FF),
      "pastelBgDark": Color(0xFF082F49),
      "route": "prayer",
    },
    {
      "label": "Qiblah Compass",
      "arabic": "اتجاه القبلة",
      "subtitle": "Sensor Direction",
      "icon": Icons.explore_rounded,
      "color": Color(0xFF10B981),
      "gradient": [Color(0xFF34D399), Color(0xFF059669)],
      "pastelBgLight": Color(0xFFF0FDF4),
      "pastelBgDark": Color(0xFF052E16),
      "route": "qiblah",
    },
    {
      "label": "Digital Tasbih",
      "arabic": "المسبحة الإلكترونية",
      "subtitle": "Dhikr & Counter",
      "icon": Icons.fingerprint_rounded,
      "color": Color(0xFF0284C7),
      "gradient": [Color(0xFF38BDF8), Color(0xFF2563EB)],
      "pastelBgLight": Color(0xFFF0F9FF),
      "pastelBgDark": Color(0xFF0C4A6E),
      "route": "tasbih",
      "badge": "Haptic",
    },
    {
      "label": "Daily Duas",
      "arabic": "حصن المسلم",
      "subtitle": "Morning & Evening",
      "icon": Icons.bookmark_added_rounded,
      "color": Color(0xFF0D9488),
      "gradient": [Color(0xFF2DD4BF), Color(0xFF0F766E)],
      "pastelBgLight": Color(0xFFF0FDFA),
      "pastelBgDark": Color(0xFF042F2C),
      "route": "duas",
    },
    {
      "label": "AI Companion",
      "arabic": "المساعد الإسلامي",
      "subtitle": "Ask Islamic Guide",
      "icon": Icons.auto_awesome_rounded,
      "color": Color(0xFF7C3AED),
      "gradient": [Color(0xFFA855F7), Color(0xFF6D28D9)],
      "pastelBgLight": Color(0xFFFAF5FF),
      "pastelBgDark": Color(0xFF280B52),
      "route": "ai_companion",
      "badge": "Smart",
    },
  ];

  static const List<Map<String, dynamic>> _secondaryPills = [
    {"label": "Hadith", "icon": Icons.library_books_rounded, "route": "hadith"},
    {"label": "Fasting", "icon": Icons.nightlight_round, "route": "fasting"},
    {"label": "Zakat", "icon": Icons.volunteer_activism_rounded, "route": "zakat"},
    {"label": "Prophets", "icon": Icons.auto_stories_rounded, "route": "prophets"},
    {"label": "Hajj Guide", "icon": Icons.apartment_rounded, "route": "hajj"},
    {"label": "Donate", "icon": Icons.favorite_rounded, "route": "donate"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Islamic Utilities",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.islamicGold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "6 Essentials",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.islamicGold,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => onNavigate("calendar"),
              child: Text(
                "Calendar & Events →",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.islamicGoldLight : AppColors.islamicIndigo,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 6-Grid Pastel Squircles (Inspired by Image 2 & Image 5)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _primaryTools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final tool = _primaryTools[index];
            final color = tool["color"] as Color;
            final pastelBg = isDark
                ? (tool["pastelBgDark"] as Color)
                : (tool["pastelBgLight"] as Color);
            final badge = tool["badge"] as String?;

            return GestureDetector(
              onTap: () => onNavigate(tool["route"] as String),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : pastelBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark
                        ? color.withOpacity(0.28)
                        : color.withOpacity(0.18),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(isDark ? 0.12 : 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: tool["gradient"] != null
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: tool["gradient"] as List<Color>,
                                  )
                                : null,
                            color: tool["gradient"] == null ? color : null,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.38),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            tool["icon"] as IconData,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        if (badge != null)
                          Positioned(
                            top: -4,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.islamicGold,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tool["label"] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      tool["arabic"] as String,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 10,
                        color: isDark ? Colors.white54 : color.withOpacity(0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // Secondary Horizontal Category Pills
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _secondaryPills.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final pill = _secondaryPills[index];

              return GestureDetector(
                onTap: () => onNavigate(pill["route"] as String),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        pill["icon"] as IconData,
                        size: 14,
                        color: isDark ? AppColors.islamicGoldLight : AppColors.islamicIndigo,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        pill["label"] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
