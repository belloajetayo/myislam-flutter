import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const List<Map<String, dynamic>> items = [
    {"label": "Home", "icon": Icons.home_rounded},
    {"label": "Prayer", "icon": Icons.access_time_filled_rounded},
    {"label": "Qiblah", "icon": Icons.explore_rounded},
    {"label": "Quran", "icon": Icons.menu_book_rounded},
    {"label": "Podcasts", "icon": Icons.headphones_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Modern Floating Capsule Pill (Inspired by Image 1 & Image 4)
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131028) : const Color(0xFF1E1B38),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(
            color: isDark ? const Color(0xFF382F5E) : const Color(0xFF3B3363),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: const Color(0xFF7E22CE).withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppColors.purpleGoldShiningGradient
                        : null,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item["icon"] as IconData,
                        size: 20,
                        color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item["label"] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          letterSpacing: 0.2,
                          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
