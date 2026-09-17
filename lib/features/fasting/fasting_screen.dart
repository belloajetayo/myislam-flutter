import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/prayer_service.dart';

class FastingScreen extends StatelessWidget {
  final VoidCallback onBack;

  const FastingScreen({super.key, required this.onBack});

  static const List<Map<String, String>> sunnahDays = [
    {"name": "Thursday Sunnah Fast", "date": "Every Thursday", "arabic": "صيام الخميس"},
    {"name": "Monday Sunnah Fast", "date": "Every Monday", "arabic": "صيام الإثنين"},
    {"name": "White Days (Ayyam al-Beed)", "date": "13th, 14th, 15th of Hijri month", "arabic": "الأيام البيض"},
    {"name": "Day of Ashura", "date": "10th Muharram", "arabic": "يوم عاشوراء"},
  ];

  @override
  Widget build(BuildContext context) {
    final prayerService = context.watch<PrayerService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final suhoorTime = prayerService.times.fajr;
    final iftarTime = prayerService.times.maghrib;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          // Header Bar
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fasting Tracker (Sawm)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                  ),
                  Text(
                    "Fourth Pillar of Islam",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Suhoor & Iftar Times Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("SUHOOR ENDS (FAJR)", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(suhoorTime, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Icon(Icons.wb_twilight_rounded, color: Color(0xFFFDE047), size: 24),
                  ],
                ),
                Container(width: 1, height: 50, color: Colors.white24),
                Column(
                  children: [
                    const Text("IFTAR TIME (MAGHRIB)", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(iftarTime, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Icon(Icons.nightlight_round, color: Color(0xFFFDE047), size: 24),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Duas for Fasting
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEF2FF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Text("🤲", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text("Dua for Breaking Fast (Iftar)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 19, fontWeight: FontWeight.bold, height: 1.8),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Dhahaba adh-dhama'u wabtallatil-'urooqu wa thabatal-ajru in sha' Allah",
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF8B5CF6)),
                ),
                const SizedBox(height: 4),
                const Text(
                  "\"The thirst has gone, the veins are moistened, and the reward is confirmed, if Allah wills.\"",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Upcoming Sunnah Fasting Days
          const Text("Recommended Sunnah Fast Days", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Column(
            children: sunnahDays.map((d) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.islamicPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.calendar_today_rounded, color: AppColors.islamicPurple, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(d["date"]!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(
                      d["arabic"]!,
                      style: const TextStyle(fontFamily: 'Amiri', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
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
