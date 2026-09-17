import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/prayer_service.dart';

class PrayerTopBar extends StatelessWidget {
  final VoidCallback? onTap;

  const PrayerTopBar({super.key, this.onTap});

  static const List<String> prayerNames = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

  @override
  Widget build(BuildContext context) {
    final prayerService = context.watch<PrayerService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final times = prayerService.times.toMap();
    final current = prayerService.currentPrayer;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.heroPrayerDarkGradient : AppColors.heroPrayerGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.islamicIndigo.withOpacity(isDark ? 0.3 : 0.25),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Hijri Date + Location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ISLAMIC DATE",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prayerService.hijriDate.formatted,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 13, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          prayerService.times.city,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 12),

              // Prayer Pills Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: prayerNames.map((name) {
                  final time = times[name] ?? "--:--";
                  final isCurrent = current == name;

                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Colors.white.withOpacity(isDark ? 0.35 : 0.28)
                            : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: isCurrent
                            ? Border.all(color: Colors.white.withOpacity(0.7), width: 1.5)
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                              color: isCurrent ? Colors.white : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
