import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/storage_service.dart';

class ProgressTrackerCard extends StatelessWidget {
  final VoidCallback onDetailsTap;

  const ProgressTrackerCard({super.key, required this.onDetailsTap});

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final completedCount = storage.prayersCompleted.length;
    final prayerPercent = (completedCount / 5.0).clamp(0.0, 1.0);
    final streakPercent = (storage.streak / 30.0).clamp(0.0, 1.0);
    final quranPercent = (storage.quranPagesRead / 20.0).clamp(0.0, 1.0);
    final duasPercent = (storage.duasRead / 10.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: "Today's Progress" + "View all >"
        GestureDetector(
          onTap: onDetailsTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, color: AppColors.islamicIndigo, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Today's Progress",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      "View all",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF6366F1)),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 4 Stat Cards Grid
        GestureDetector(
          onTap: onDetailsTap,
          child: Row(
            children: [
              _buildStatItem(
                label: "Salat",
                value: "$completedCount/5",
                icon: Icons.track_changes_rounded,
                colors: const [Color(0xFF6366F1), Color(0xFF2563EB)],
                progress: prayerPercent,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: "Streak",
                value: "${storage.streak}d",
                icon: Icons.local_fire_department_rounded,
                colors: const [Color(0xFFF97316), Color(0xFFEF4444)],
                progress: streakPercent,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: "Quran",
                value: "${storage.quranPagesRead}pg",
                icon: Icons.menu_book_rounded,
                colors: const [Color(0xFF10B981), Color(0xFF0D9488)],
                progress: quranPercent,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: "Duas",
                value: "${storage.duasRead}",
                icon: Icons.volunteer_activism_rounded,
                colors: const [Color(0xFFA855F7), Color(0xFF7C3AED)],
                progress: duasPercent,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required List<Color> colors,
    required double progress,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(colors.first),
                minHeight: 3.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
