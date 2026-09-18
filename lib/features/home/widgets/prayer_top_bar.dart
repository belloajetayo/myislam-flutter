import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/prayer_service.dart';
import '../../../data/services/audio_service.dart';

class PrayerTopBar extends StatelessWidget {
  final VoidCallback? onTap;

  const PrayerTopBar({super.key, this.onTap});

  static const List<Map<String, String>> prayersList = [
    {"name": "Fajr", "arabic": "الفجر"},
    {"name": "Sunrise", "arabic": "الشروق"},
    {"name": "Dhuhr", "arabic": "الظهر"},
    {"name": "Asr", "arabic": "العصر"},
    {"name": "Maghrib", "arabic": "المغرب"},
    {"name": "Isha", "arabic": "العشاء"},
  ];

  LinearGradient _getPrayerGradient(String prayer, bool isDark) {
    switch (prayer.toLowerCase()) {
      case "fajr":
        return AppColors.fajrDawnGradient;
      case "sunrise":
        return AppColors.sunriseGradient;
      case "dhuhr":
        return AppColors.dhuhrAzureGradient;
      case "asr":
        return AppColors.asrAmberGradient;
      case "maghrib":
        return AppColors.maghribDuskGradient;
      case "isha":
      default:
        return isDark ? AppColors.ishaNightGradient : AppColors.emeraldHeroGradient;
    }
  }

  void _playAdhanPreview(BuildContext context) {
    final audioService = context.read<AudioService>();
    // High-quality Makkah Haram Adhan stream
    const adhanUrl = "https://server8.mp3quran.net/athan/01_Makkah.mp3";
    audioService.playStream(
      adhanUrl,
      title: "Adhan Makkah Al-Mukarramah",
      subtitle: "Call to Prayer • الشيخ علي ملا",
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Playing Adhan from Makkah Al-Mukarramah 🕋"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prayerService = context.watch<PrayerService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final times = prayerService.times.toMap();
    final current = prayerService.currentPrayer;
    final gradient = _getPrayerGradient(current, isDark);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(isDark ? 0.4 : 0.3),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Decorative background moon & minaret watermark
            Positioned(
              right: -15,
              top: -15,
              child: Opacity(
                opacity: 0.12,
                child: Text(
                  "🕌",
                  style: TextStyle(fontSize: 140, color: Colors.white.withOpacity(0.9)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Islamic Date + City Badge + Adhan Audio Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Islamic Date
                      Row(
                        children: [
                          const Text("🌙", style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "HIJRI DATE",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                prayerService.hijriDate.formatted,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // City Location Badge + Adhan Preview
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on_rounded, size: 12, color: Colors.white),
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
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _playAdhanPreview(context),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.goldWarm,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.goldWarm.withOpacity(0.4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Middle Row: Current Prayer Name & Next Prayer Countdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "CURRENT PRAYER",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.goldWarm,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                current,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                times[current] ?? "--:--",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Next prayer countdown pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 14, color: AppColors.goldLight),
                            const SizedBox(width: 6),
                            Text(
                              "${prayerService.nextPrayer} in ${prayerService.timeUntilNext}",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Divider(height: 1, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 12),

                  // Bottom Prayer Checkpoints (6 prayers)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: prayersList.map((p) {
                      final name = p["name"]!;
                      final time = times[name] ?? "--:--";
                      final isCurrent = current.toLowerCase() == name.toLowerCase();

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? Colors.white.withOpacity(isDark ? 0.35 : 0.28)
                                : Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: isCurrent
                                ? Border.all(color: Colors.white.withOpacity(0.85), width: 1.5)
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                                  color: isCurrent ? Colors.white : Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (isCurrent)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: AppColors.goldWarm,
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
          ],
        ),
      ),
    );
  }
}
