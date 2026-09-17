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

    final stats = [
      {
        "label": "Salat",
        "value": "${storage.prayersCompleted.length}/5",
        "icon": Icons.track_changes_rounded,
        "progress": storage.prayersCompleted.length / 5.0,
        "gradient": AppColors.salatGradient,
      },
      {
        "label": "Streak",
        "value": "${storage.streak}d",
        "icon": Icons.local_fire_department_rounded,
        "progress": (storage.streak / 30.0).clamp(0.0, 1.0),
        "gradient": const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEF4444)]),
      },
      {
        "label": "Quran",
        "value": "${storage.quranPagesRead}pg",
        "icon": Icons.menu_book_rounded,
        "progress": (storage.quranPagesRead / 20.0).clamp(0.0, 1.0),
        "gradient": AppColors.quranGradient,
      },
      {
        "label": "Duas",
        "value": "${storage.duasRead}",
        "icon": Icons.volunteer_activism_rounded,
        "progress": (storage.duasRead / 10.0).clamp(0.0, 1.0),
        "gradient": AppColors.sawmGradient,
      },
    ];

    return Column(
      children: [
        // Header
        InkWell(
          onTap: onDetailsTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
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
                Row(
                  children: [
                    Text(
                      "View all",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.islamicIndigo : const Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF6366F1)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Metric cards row
        Row(
          children: stats.map((item) {
            final gradient = item["gradient"] as LinearGradient;
            final progress = item["progress"] as double;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.all(10),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item["icon"] as IconData, color: Colors.white, size: 15),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item["value"] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Mini progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        height: 4,
                        color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(gradient: gradient),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["label"] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
