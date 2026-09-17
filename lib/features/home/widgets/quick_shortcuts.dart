import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QuickShortcuts extends StatefulWidget {
  final Function(String routeName) onNavigate;

  const QuickShortcuts({super.key, required this.onNavigate});

  @override
  State<QuickShortcuts> createState() => _QuickShortcutsState();
}

class _QuickShortcutsState extends State<QuickShortcuts> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _primaryShortcuts = [
    {"label": "Quran", "icon": Icons.menu_book_rounded, "gradient": AppColors.quranGradient, "route": "quran"},
    {"label": "Salat", "icon": Icons.access_time_filled_rounded, "gradient": AppColors.salatGradient, "route": "prayer"},
    {"label": "Zakat", "icon": Icons.volunteer_activism_rounded, "gradient": AppColors.zakatGradient, "route": "zakat"},
    {"label": "Sawm", "icon": Icons.nightlight_round, "gradient": AppColors.sawmGradient, "route": "fasting"},
    {"label": "Hajj", "icon": Icons.location_on_rounded, "gradient": AppColors.hajjGradient, "route": "hajj"},
  ];

  final List<Map<String, dynamic>> _extraShortcuts = [
    {"label": "Duas", "icon": Icons.bookmark_rounded, "gradient": [0xFF14B8A6, 0xFF06B6D4], "route": "duas"},
    {"label": "Qiblah", "icon": Icons.explore_rounded, "gradient": [0xFF22C55E, 0xFF059669], "route": "qiblah"},
    {"label": "Radio", "icon": Icons.headphones_rounded, "gradient": [0xFF3B82F6, 0xFF1D4ED8], "route": "podcasts"},
    {"label": "Donate", "icon": Icons.favorite_rounded, "gradient": [0xFFEF4444, 0xFFF43F5E], "route": "donate"},
    {"label": "Profile", "icon": Icons.person_rounded, "gradient": [0xFF64748B, 0xFF475569], "route": "profile"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          children: [
            Text(
              "Pillars of Islam",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.islamicIndigo.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Primary 5 Columns
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _primaryShortcuts.map((s) => _buildShortcutItem(
            label: s["label"] as String,
            icon: s["icon"] as IconData,
            gradient: s["gradient"] as LinearGradient,
            route: s["route"] as String,
            isDark: isDark,
          )).toList(),
        ),

        // More / Less Toggle Button
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0x336366F1) : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0x556366F1) : const Color(0xFFC7D2FE),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? "Less" : "More",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.islamicIndigo,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AppColors.islamicIndigo,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Expanded Extra Shortcuts
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _extraShortcuts.map((s) {
                final colors = (s["gradient"] as List<int>).map((c) => Color(c)).toList();
                return _buildShortcutItem(
                  label: s["label"] as String,
                  icon: s["icon"] as IconData,
                  gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  route: s["route"] as String,
                  isDark: isDark,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShortcutItem({
    required String label,
    required IconData icon,
    required LinearGradient gradient,
    required String route,
    required bool isDark,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onNavigate(route),
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
