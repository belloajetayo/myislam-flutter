import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/dua_model.dart';

class DuaCategoryCard extends StatelessWidget {
  final DuaCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const DuaCategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = category.gradientColors.map((c) => Color(c)).toList();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? colors.first.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.05))
              : (isSelected ? colors.first.withValues(alpha: 0.08) : Colors.white),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? colors.first
                : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? colors.first.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row: Category Icon & Dua count badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: colors.first.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      category.icon,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.first
                        : (isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${category.duaCount} Duas",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Arabic Title
            if (category.arabicName.isNotEmpty)
              Text(
                category.arabicName,
                textDirection: TextDirection.rtl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? colors.first : (isDark ? Colors.white70 : const Color(0xFF475569)),
                ),
              ),

            // English Name
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 2),

            // Description
            Text(
              category.desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.3,
                color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
