import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/storage_service.dart';

class ProgressTrackerCard extends StatelessWidget {
  final VoidCallback onDetailsTap;

  const ProgressTrackerCard({super.key, required this.onDetailsTap});

  static const List<String> dailyPrayers = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completedCount = storage.prayersCompleted.length;
    final progressPct = (completedCount / 5.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Completion %
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.islamicGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: AppColors.islamicGold, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Prayer Tracker",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        "$completedCount of 5 prayed today • ${(progressPct * 100).round()}%",
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              // Streak badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEF4444)]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF97316).withOpacity(0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      "${storage.streak}d Streak",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Linear progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressPct,
              minHeight: 6,
              backgroundColor: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
              color: AppColors.islamicGold,
            ),
          ),

          const SizedBox(height: 16),

          // 5 Prayer Interactive Checkboxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dailyPrayers.map((prayer) {
              final isDone = storage.prayersCompleted.contains(prayer);

              return Expanded(
                child: GestureDetector(
                  onTap: () => storage.togglePrayer(prayer),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isDone
                          ? (isDark ? AppColors.islamicPurple.withOpacity(0.25) : const Color(0xFFFAF5FF))
                          : (isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDone
                            ? AppColors.islamicPurple
                            : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                        width: isDone ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? AppColors.islamicPurple : Colors.transparent,
                            border: Border.all(
                              color: isDone ? AppColors.islamicPurple : Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          child: isDone
                              ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                              : null,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          prayer,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isDone ? FontWeight.bold : FontWeight.w600,
                            color: isDone
                                ? AppColors.islamicPurple
                                : (isDark ? Colors.white70 : AppColors.lightTextPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
