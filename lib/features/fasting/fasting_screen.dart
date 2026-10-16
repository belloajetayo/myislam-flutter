import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/services/prayer_service.dart';
import '../../data/services/audio_service.dart';

enum FastStatus { fasted, missed, qada, none }

class FastingScreen extends StatefulWidget {
  final VoidCallback onBack;

  const FastingScreen({super.key, required this.onBack});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  // 30 days Ramadan log status
  final Map<int, FastStatus> _fastingLog = {
    1: FastStatus.fasted,
    2: FastStatus.fasted,
    3: FastStatus.fasted,
    4: FastStatus.fasted,
    5: FastStatus.fasted,
    6: FastStatus.fasted,
    7: FastStatus.fasted,
    8: FastStatus.fasted,
    9: FastStatus.fasted,
    10: FastStatus.fasted,
    11: FastStatus.fasted,
    12: FastStatus.fasted,
    13: FastStatus.missed,
    14: FastStatus.qada,
    15: FastStatus.fasted,
  };

  int get _fastedCount => _fastingLog.values.where((v) => v == FastStatus.fasted || v == FastStatus.qada).length;
  int get _missedCount => _fastingLog.values.where((v) => v == FastStatus.missed).length;

  static const List<String> rewardedActions = [
    "Reciting Holy Quran daily",
    "Giving extra charity (Sadaqah)",
    "Guarding the tongue & gaze",
    "Making heartfelt dua at Iftar",
    "Praying Tahajjud & Taraweeh",
    "Feeding a fasting person (Iftar)",
  ];

  static const List<String> thingsToAvoid = [
    "Anger, arguments & foul speech",
    "Backbiting (Gheebah) & gossip",
    "Wasting time on idle vain speech",
    "Overeating heavily at Iftar time",
    "Missing obligatory prayers while fasting",
  ];

  static const List<Map<String, String>> sunnahDays = [
    {"name": "Thursday Sunnah Fast", "date": "Every Thursday", "arabic": "صيام الخميس"},
    {"name": "Monday Sunnah Fast", "date": "Every Monday", "arabic": "صيام الإثنين"},
    {"name": "White Days (Ayyam al-Beed)", "date": "13th, 14th, 15th of Hijri month", "arabic": "الأيام البيض"},
    {"name": "Day of Ashura", "date": "10th Muharram", "arabic": "يوم عاشوراء"},
    {"name": "Day of Arafah", "date": "9th Dhul-Hijjah", "arabic": "يوم عرفة"},
  ];

  void _cycleFastStatus(int day) {
    setState(() {
      final current = _fastingLog[day] ?? FastStatus.none;
      switch (current) {
        case FastStatus.none:
          _fastingLog[day] = FastStatus.fasted;
          break;
        case FastStatus.fasted:
          _fastingLog[day] = FastStatus.missed;
          break;
        case FastStatus.missed:
          _fastingLog[day] = FastStatus.qada;
          break;
        case FastStatus.qada:
          _fastingLog[day] = FastStatus.none;
          break;
      }
    });
  }

  void _playDuaAudio(BuildContext context, String title) {
    final audioService = context.read<AudioService>();
    // High quality Islamic recitation
    const audioUrl = "https://server8.mp3quran.net/athan/01_Makkah.mp3";
    audioService.playStream(audioUrl, title: title, subtitle: "Fasting Supplication • دعاء الصائم");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Playing $title audio 🤲"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prayerService = context.watch<PrayerService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final suhoorTime = prayerService.times.fajr;
    final iftarTime = prayerService.times.maghrib;

    // Calculate approximate fasting day progress
    final now = DateTime.now();
    // Default approx 5:30 to 18:45
    final progress = ((now.hour * 60 + now.minute - 330) / (1125 - 330)).clamp(0.0, 1.0);
    final isFastingHours = now.hour >= 5 && (now.hour < 19 || (now.hour == 18 && now.minute <= 45));

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          // Header Bar
          Row(
            children: [
              AnimatedBackButton(onPressed: widget.onBack),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fasting Tracker (الصيام)",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                    ),
                    Text(
                      "Fourth Pillar of Islam • Sawm & Ramadan",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.nightlight_round, color: Color(0xFFFDE047), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "$_fastedCount/30 Fasted",
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Suhoor & Iftar Live Banner Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4338CA).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Suhoor End (Fajr)
                    Column(
                      children: [
                        Text(
                          "SUHOOR ENDS (FAJR)",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          suhoorTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.wb_twilight_rounded, color: Color(0xFFFDE047), size: 16),
                            SizedBox(width: 4),
                            Text("Start Fast", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),

                    Container(width: 1, height: 55, color: Colors.white.withOpacity(0.2)),

                    // Iftar Time (Maghrib)
                    Column(
                      children: [
                        Text(
                          "IFTAR TIME (MAGHRIB)",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          iftarTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.nightlight_round, color: Color(0xFFFDE047), size: 16),
                            SizedBox(width: 4),
                            Text("Break Fast", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.white.withOpacity(0.18)),
                const SizedBox(height: 12),

                // Fasting Progress Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isFastingHours ? Icons.hourglass_top_rounded : Icons.check_circle_rounded,
                          color: const Color(0xFFFDE047),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isFastingHours
                              ? "Today's Fast: ${(progress * 100).toInt()}% completed"
                              : "Night Hours: Rest & Prepare for Suhoor",
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      isFastingHours ? "Maghrib: $iftarTime" : "Fajr: $suhoorTime",
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: isFastingHours ? progress : 1.0,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFDE047)),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 30-Day Ramadan / Fasting Log Tracker Grid
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(24),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "30-Day Fasting Log",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Tap a day to toggle: Fasted • Missed • Qada",
                          style: TextStyle(fontSize: 10.5, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildStatusDot(const Color(0xFF10B981), "Fasted"),
                        const SizedBox(width: 8),
                        _buildStatusDot(const Color(0xFFEF4444), "Missed"),
                        const SizedBox(width: 8),
                        _buildStatusDot(const Color(0xFFF59E0B), "Qada"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 30-Day Interactive Grid (6 cols x 5 rows)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 30,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final dayNum = index + 1;
                    final status = _fastingLog[dayNum] ?? FastStatus.none;

                    Color bg;
                    Color border;
                    Color textCol;
                    IconData? icon;

                    switch (status) {
                      case FastStatus.fasted:
                        bg = const Color(0xFF10B981).withOpacity(0.18);
                        border = const Color(0xFF10B981);
                        textCol = const Color(0xFF10B981);
                        icon = Icons.check_rounded;
                        break;
                      case FastStatus.missed:
                        bg = const Color(0xFFEF4444).withOpacity(0.18);
                        border = const Color(0xFFEF4444);
                        textCol = const Color(0xFFEF4444);
                        icon = Icons.close_rounded;
                        break;
                      case FastStatus.qada:
                        bg = const Color(0xFFF59E0B).withOpacity(0.18);
                        border = const Color(0xFFF59E0B);
                        textCol = const Color(0xFFF59E0B);
                        icon = Icons.restore_rounded;
                        break;
                      case FastStatus.none:
                        bg = isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC);
                        border = isDark ? Colors.white10 : const Color(0xFFE2E8F0);
                        textCol = isDark ? Colors.white60 : Colors.grey[700]!;
                        icon = null;
                        break;
                    }

                    return GestureDetector(
                      onTap: () => _cycleFastStatus(dayNum),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border, width: 1.2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$dayNum",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textCol,
                              ),
                            ),
                            if (icon != null)
                              Icon(icon, size: 12, color: textCol),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                // Qada Needed Tracker Callout
                if (_missedCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "You have $_missedCount missed fast(s) to make up (Qada) before next Ramadan.",
                            style: const TextStyle(fontSize: 11, color: Color(0xFFEF4444), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Authentic Fasting Duas Section (Iftar & Suhoor)
          const Text("Authentic Fasting Supplications", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // 1. Iftar Dua Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("🌅", style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text("Dua for Breaking Fast (Iftar)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF8B5CF6), size: 20),
                      onPressed: () => _playDuaAudio(context, "Dua at Iftar"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold, height: 1.8),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Dhahaba adh-dhama'u wabtallatil-'urooqu wa thabatal-ajru in sha' Allah",
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF8B5CF6)),
                ),
                const SizedBox(height: 4),
                const Text(
                  "\"The thirst has gone, the veins are moistened, and the reward is confirmed, if Allah wills.\" [Abu Dawud 2357]",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. Suhoor Intention Dua Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("🌙", style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text("Suhoor Intention (Niyyah)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF8B5CF6), size: 20),
                      onPressed: () => _playDuaAudio(context, "Suhoor Intention"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "وَبِصَوْمِ غَدٍ نَوَيْتُ مِنْ شَهْرِ رَمَضَانَ",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold, height: 1.8),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Wa bisawmi ghadinn nawaytu min shahri Ramadan",
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF8B5CF6)),
                ),
                const SizedBox(height: 4),
                const Text(
                  "\"I intend to fast tomorrow in the sacred month of Ramadan for the sake of Allah.\"",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Rewarded Actions & Things to Avoid
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

          // Recommended Sunnah Fast Days
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

  Widget _buildStatusDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9.5, color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
