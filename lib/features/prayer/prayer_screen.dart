import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/prayer_service.dart';
import '../../data/services/storage_service.dart';

class PrayerScreen extends StatefulWidget {
  final VoidCallback onBack;

  const PrayerScreen({super.key, required this.onBack});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  int _selectedDayOffset = 0; // 0 is today, -3 to +3
  bool _notificationsEnabled = true;

  static const List<Map<String, dynamic>> prayersList = [
    {"name": "Fajr", "arabic": "الفجر", "color": [0xFF6366F1, 0xFF8B5CF6]},
    {"name": "Sunrise", "arabic": "الشروق", "color": [0xFFFB923C, 0xFFEC4899]},
    {"name": "Dhuhr", "arabic": "الظهر", "color": [0xFFF59E0B, 0xFFEA580C]},
    {"name": "Asr", "arabic": "العصر", "color": [0xFF22D3EE, 0xFF3B82F6]},
    {"name": "Maghrib", "arabic": "المغرب", "color": [0xFFA855F7, 0xFFEC4899]},
    {"name": "Isha", "arabic": "العشاء", "color": [0xFF2563EB, 0xFF4338CA]},
  ];

  @override
  Widget build(BuildContext context) {
    final prayerService = context.watch<PrayerService>();
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final times = prayerService.times.toMap();
    final current = prayerService.currentPrayer;

    final now = DateTime.now();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          // Header Bar
          Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, size: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prayer Times",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.islamicGold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 12, color: AppColors.islamicGold),
                        const SizedBox(width: 3),
                        Text(
                          "${prayerService.times.city}, ${prayerService.times.country}",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _notificationsEnabled = !_notificationsEnabled);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _notificationsEnabled
                            ? "Prayer notifications enabled! 🔔"
                            : "Prayer notifications muted 🔕",
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _notificationsEnabled
                        ? AppColors.islamicGold.withOpacity(0.15)
                        : (isDark ? Colors.white.withOpacity(0.08) : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _notificationsEnabled
                          ? AppColors.islamicGold.withOpacity(0.5)
                          : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Icon(
                    _notificationsEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                    color: AppColors.islamicGold,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Date Selector Strip (-3 to +3)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (idx) {
                final offset = idx - 3;
                final date = now.add(Duration(days: offset));
                final isSelected = offset == _selectedDayOffset;
                final dayName = DateFormat('E').format(date);
                final dayNum = date.day.toString();

                return GestureDetector(
                  onTap: () => setState(() => _selectedDayOffset = offset),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.heroPrayerGradient : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayNum,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Hero Current Prayer Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CURRENT PRAYER",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      current,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      prayersList.firstWhere(
                        (p) => p["name"] == current,
                        orElse: () => {"arabic": ""},
                      )["arabic"] as String,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      times[current] ?? "--:--",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Next: ${prayerService.nextPrayer} in ${prayerService.timeUntilNext}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // All Prayers List
          Text(
            "All Prayers",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Column(
            children: prayersList.map((p) {
              final name = p["name"] as String;
              final arabic = p["arabic"] as String;
              final colors = (p["color"] as List<int>).map((c) => Color(c)).toList();
              final isCurrent = current == name;
              final time = times[name] ?? "--:--";
              final isPrayed = storage.prayersCompleted.contains(name);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.islamicGold.withOpacity(0.8)
                        : (isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF)),
                    width: isCurrent ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Arabic Initial Badge
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: colors),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        arabic.characters.first,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Name + Arabic
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              if (isCurrent) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.goldGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Now",
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            arabic,
                            style: const TextStyle(fontFamily: 'Amiri', fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // Time
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isCurrent ? AppColors.islamicGold : null,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Checkmark toggle button
                    GestureDetector(
                      onTap: () => storage.togglePrayer(name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPrayed
                              ? const Color(0xFF10B981)
                              : (isDark ? Colors.white12 : const Color(0xFFF1F5F9)),
                          border: Border.all(
                            color: isPrayed ? const Color(0xFF10B981) : Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        child: isPrayed
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                            : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
