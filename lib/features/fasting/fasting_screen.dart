import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/services/prayer_service.dart';

class FastingScreen extends StatefulWidget {
  final VoidCallback onBack;

  const FastingScreen({super.key, required this.onBack});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  bool _todayFasted = false;
  int _fastedDays = 14;

  static const List<String> rewardedActions = [
    "Reciting Holy Quran daily",
    "Giving extra charity (Sadaqah)",
    "Guarding the tongue & gaze",
    "Making heartfelt dua at Iftar",
    "Praying Tahajjud & Taraweeh",
  ];

  static const List<String> thingsToAvoid = [
    "Anger, arguments & swearing",
    "Backbiting (Gheebah) & slander",
    "Wasting time on vanity",
    "Overeating at Iftar time",
  ];

  static const List<Map<String, String>> sunnahDays = [
    {"name": "Thursday Sunnah Fast", "date": "Every Thursday", "arabic": "صيام الخميس"},
    {"name": "Monday Sunnah Fast", "date": "Every Monday", "arabic": "صيام الإثنين"},
    {"name": "White Days (Ayyam al-Beed)", "date": "13th, 14th, 15th of Hijri month", "arabic": "الأيام البيض"},
    {"name": "Day of Ashura", "date": "10th Muharram", "arabic": "يوم عاشوراء"},
  ];

  void _toggleFasting() {
    setState(() {
      _todayFasted = !_todayFasted;
      if (_todayFasted) {
        _fastedDays++;
      } else {
        _fastedDays--;
      }
    });
  }

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
              AnimatedBackButton(onPressed: widget.onBack),
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

          // Fasting Tracker Card (from Fasting.tsx)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEA580C)]),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.nightlight_round, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Fasting Counter",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              "Track your fasts for Allah",
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "$_fastedDays",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryGold,
                          ),
                        ),
                        const Text(
                          "Days Fasted",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Mark Today as Fasted Button
                GestureDetector(
                  onTap: _toggleFasting,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: _todayFasted
                          ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF0D9488)])
                          : AppColors.activeNavPillGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (_todayFasted ? const Color(0xFF10B981) : const Color(0xFF6366F1)).withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _todayFasted ? Icons.check_circle_rounded : Icons.nightlight_round,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _todayFasted ? "Alhamdulillah — Fasted Today" : "Mark Today as Fasted",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

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

          // Rewarded Actions & Things to Avoid (from Fasting.tsx)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                          SizedBox(width: 6),
                          Text("Rewarded", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...rewardedActions.map((a) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(a, style: const TextStyle(fontSize: 10.5, height: 1.3)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 16),
                          SizedBox(width: 6),
                          Text("To Avoid", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFEF4444))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...thingsToAvoid.map((a) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(a, style: const TextStyle(fontSize: 10.5, height: 1.3)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Duas for Fasting (Iftar & Suhoor)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text("🤲", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text("Dua for Breaking Fast (Iftar)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 19, fontWeight: FontWeight.bold, height: 1.8),
                ),
                SizedBox(height: 6),
                Text(
                  "Dhahaba adh-dhama'u wabtallatil-'urooqu wa thabatal-ajru in sha' Allah",
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF8B5CF6)),
                ),
                SizedBox(height: 4),
                Text(
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
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
