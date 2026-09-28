import 'package:flutter/material.dart';

class QuickShortcuts extends StatefulWidget {
  final Function(String routeName) onNavigate;

  const QuickShortcuts({super.key, required this.onNavigate});

  @override
  State<QuickShortcuts> createState() => _QuickShortcutsState();
}

class _QuickShortcutsState extends State<QuickShortcuts> {
  bool _expanded = false;

  static const List<Map<String, dynamic>> _primaryShortcuts = [
    {
      "icon": Icons.menu_book_rounded,
      "label": "Quran",
      "colors": [Color(0xFF10B981), Color(0xFF0D9488)],
      "route": "quran",
    },
    {
      "icon": Icons.volunteer_activism_rounded,
      "label": "Salat",
      "colors": [Color(0xFF3B82F6), Color(0xFF4F46E5)],
      "route": "prayer",
    },
    {
      "icon": Icons.water_drop_rounded,
      "label": "Zakat",
      "colors": [Color(0xFFF59E0B), Color(0xFFEA580C)],
      "route": "zakat",
    },
    {
      "icon": Icons.nightlight_round,
      "label": "Sawm",
      "colors": [Color(0xFFA855F7), Color(0xFF7C3AED)],
      "route": "fasting",
    },
    {
      "icon": Icons.location_on_rounded,
      "label": "Hajj",
      "colors": [Color(0xFFF43F5E), Color(0xFFDB2777)],
      "route": "hajj",
    },
  ];

  static const List<Map<String, dynamic>> _extraShortcuts = [
    {
      "icon": Icons.bookmark_added_rounded,
      "label": "Duas",
      "colors": [Color(0xFF14B8A6), Color(0xFF06B6D4)],
      "route": "duas",
    },
    {
      "icon": Icons.library_books_rounded,
      "label": "Hadith",
      "colors": [Color(0xFFF97316), Color(0xFFF59E0B)],
      "route": "hadith",
    },
    {
      "icon": Icons.star_rounded,
      "label": "Prophet",
      "colors": [Color(0xFFEAB308), Color(0xFFF97316)],
      "route": "prophets",
    },
    {
      "icon": Icons.calendar_month_rounded,
      "label": "Calendar",
      "colors": [Color(0xFF6366F1), Color(0xFF3B82F6)],
      "route": "calendar",
    },
    {
      "icon": Icons.explore_rounded,
      "label": "Qiblah",
      "colors": [Color(0xFF22C55E), Color(0xFF10B981)],
      "route": "qiblah",
    },
    {
      "icon": Icons.fingerprint_rounded,
      "label": "Tasbih",
      "colors": [Color(0xFF0284C7), Color(0xFF2563EB)],
      "route": "tasbih",
    },
    {
      "icon": Icons.favorite_rounded,
      "label": "Donate",
      "colors": [Color(0xFFEF4444), Color(0xFFF43F5E)],
      "route": "donate",
    },
    {
      "icon": Icons.person_rounded,
      "label": "Profile",
      "colors": [Color(0xFF64748B), Color(0xFF475569)],
      "route": "profile",
    },
    {
      "icon": Icons.headphones_rounded,
      "label": "Podcasts",
      "colors": [Color(0xFF8B5CF6), Color(0xFF6366F1)],
      "route": "podcasts",
    },
    {
      "icon": Icons.trending_up_rounded,
      "label": "Progress",
      "colors": [Color(0xFF2563EB), Color(0xFF4338CA)],
      "route": "progress",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title: Pillars of Islam with divider line
        Row(
          children: [
            Text(
              "Pillars of Islam",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDark ? const Color(0xFF4338CA) : const Color(0xFFC7D2FE),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Primary 5 Pillars Grid (5 columns)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _primaryShortcuts.map((s) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _buildShortcutButton(
                  icon: s["icon"] as IconData,
                  label: s["label"] as String,
                  colors: s["colors"] as List<Color>,
                  onTap: () => widget.onNavigate(s["route"] as String),
                  isDark: isDark,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 10),

        // V Chevron Expand / Collapse Button
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF312E81).withOpacity(0.3) : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF4338CA) : const Color(0xFFC7D2FE),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _expanded ? "Less" : "More",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Collapsible Extra Shortcuts
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                // Row 1 of extra shortcuts (5 items)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _extraShortcuts.sublist(0, 5).map((s) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _buildShortcutButton(
                          icon: s["icon"] as IconData,
                          label: s["label"] as String,
                          colors: s["colors"] as List<Color>,
                          onTap: () => widget.onNavigate(s["route"] as String),
                          isDark: isDark,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                // Row 2 of extra shortcuts (5 items)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _extraShortcuts.sublist(5, 10).map((s) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _buildShortcutButton(
                          icon: s["icon"] as IconData,
                          label: s["label"] as String,
                          colors: s["colors"] as List<Color>,
                          onTap: () => widget.onNavigate(s["route"] as String),
                          isDark: isDark,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  Widget _buildShortcutButton({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF2C274E) : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 19),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
