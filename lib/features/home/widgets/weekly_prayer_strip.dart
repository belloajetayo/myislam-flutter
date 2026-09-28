import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/storage_service.dart';

class WeeklyPrayerStrip extends StatefulWidget {
  final VoidCallback? onOpenPrayerScreen;

  const WeeklyPrayerStrip({super.key, this.onOpenPrayerScreen});

  @override
  State<WeeklyPrayerStrip> createState() => _WeeklyPrayerStripState();
}

class _WeeklyPrayerStripState extends State<WeeklyPrayerStrip> {
  late DateTime _selectedDate;
  late DateTime _startOfWeek;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    // Find Monday of the current week (or Sunday)
    _startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
  }

  static const List<String> _prayerNames = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    final monthName = DateFormat('MMMM yyyy').format(_selectedDate);

    final completedCount = storage.prayersCompleted.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Month & Completion summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.islamicGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: AppColors.islamicGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    monthName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: widget.onOpenPrayerScreen,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.islamicGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$completedCount/5 Prayed Today",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.islamicGreen,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.islamicGreen),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 7-Day Interactive Strip (Mon - Sun)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final dayDate = _startOfWeek.add(Duration(days: index));
              final isToday = dayDate.year == today.year &&
                  dayDate.month == today.month &&
                  dayDate.day == today.day;
              final isSelected = dayDate.year == _selectedDate.year &&
                  dayDate.month == _selectedDate.month &&
                  dayDate.day == _selectedDate.day;

              final weekdayLabel = DateFormat('E').format(dayDate).substring(0, 3);
              final dayNumber = dayDate.day.toString();

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = dayDate);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? (isDark
                            ? const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ))
                        : null,
                    color: !isSelected
                        ? (isToday
                            ? (isDark ? const Color(0x286366F1) : const Color(0xFFEEF2FF))
                            : Colors.transparent)
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isToday && !isSelected
                          ? AppColors.islamicIndigo.withOpacity(0.5)
                          : (isSelected ? Colors.transparent : Colors.transparent),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weekdayLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dayNumber,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 5 Mini dots representing 5 daily prayers
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (dotIndex) {
                          final prayerName = _prayerNames[dotIndex];
                          // For today, check actual storage; for other days show indicator
                          final isCompleted = isToday
                              ? storage.prayersCompleted.contains(prayerName)
                              : (dayDate.isBefore(today) ? true : false);

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 3.5,
                            height: 3.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? (isCompleted ? const Color(0xFFFBBF24) : Colors.white38)
                                  : (isCompleted
                                      ? AppColors.islamicGreen
                                      : (isDark ? Colors.white24 : const Color(0xFFCBD5E1))),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Quick Prayer Check-off Row for the selected day
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _prayerNames.map((prayer) {
                final isDone = storage.prayersCompleted.contains(prayer);

                return GestureDetector(
                  onTap: () => storage.togglePrayer(prayer),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.islamicGreen.withOpacity(0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDone
                            ? AppColors.islamicGreen
                            : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          size: 13,
                          color: isDone
                              ? AppColors.islamicGreen
                              : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          prayer,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                            color: isDone
                                ? AppColors.islamicGreen
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
