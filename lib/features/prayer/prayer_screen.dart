import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/services/prayer_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/audio_service.dart';

class PrayerScreen extends StatefulWidget {
  final VoidCallback onBack;

  const PrayerScreen({super.key, required this.onBack});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  int _selectedDayOffset = 0; // 0 is today, -3 to +3
  bool _notificationsEnabled = true;
  int _activeTabIndex = 0; // 0: Schedule, 1: Qaza Tracker, 2: Adhan Audio & Dua
  String? _expandedPrayer = "Fajr"; // Active expanded accordion (Image 1 pattern)

  static const List<Map<String, dynamic>> prayersList = [
    {
      "name": "Fajr",
      "arabic": "الفجر",
      "color": [0xFF6366F1, 0xFF8B5CF6],
      "rakats": "2 Sunnah (Emphasized) • 2 Fard",
      "timingDesc": "Dawn until sunrise. Highly rewarded Sunnah prayer.",
      "dhikr": "Sayyidul Istighfar & SubhanAllahi wa bihamdih (100x)",
      "adhanUrl": "https://server8.mp3quran.net/athan/01_Makkah.mp3",
    },
    {
      "name": "Sunrise",
      "arabic": "الشروق",
      "color": [0xFFFB923C, 0xFFEC4899],
      "rakats": "2 to 8 Rak'ahs (Salat ad-Duha)",
      "timingDesc": "Sunrise marks the end of Fajr. 15-20 min after sunrise, Duha time starts.",
      "dhikr": "Dua for morning light & sustenance",
      "adhanUrl": null,
    },
    {
      "name": "Dhuhr",
      "arabic": "الظهر",
      "color": [0xFFF59E0B, 0xFFEA580C],
      "rakats": "4 Sunnah • 4 Fard • 2 Sunnah",
      "timingDesc": "Just after true midday sun until shadow equals object length.",
      "dhikr": "Ayatul Kursi & Tasbih az-Zahra (33x, 33x, 34x)",
      "adhanUrl": "https://server8.mp3quran.net/athan/01_Makkah.mp3",
    },
    {
      "name": "Asr",
      "arabic": "العصر",
      "color": [0xFF0284C7, 0xFF0EA5E9],
      "rakats": "4 Fard (Preserve the Middle Prayer)",
      "timingDesc": "Afternoon prayer until sky turns orange before sunset.",
      "dhikr": "Evening Adhkar & protection against distress",
      "adhanUrl": "https://server8.mp3quran.net/athan/01_Makkah.mp3",
    },
    {
      "name": "Maghrib",
      "arabic": "المغرب",
      "color": [0xFFA855F7, 0xFFEC4899],
      "rakats": "3 Fard • 2 Sunnah",
      "timingDesc": "Immediately after sunset. Time to break fast (Iftar).",
      "dhikr": "Surah Al-Falaq & An-Nas (3x) + Maghrib Dua",
      "adhanUrl": "https://server8.mp3quran.net/athan/01_Makkah.mp3",
    },
    {
      "name": "Isha",
      "arabic": "العشاء",
      "color": [0xFF2563EB, 0xFF4338CA],
      "rakats": "4 Fard • 2 Sunnah • 1 or 3 Witr",
      "timingDesc": "Disappearance of twilight into the night until middle of night.",
      "dhikr": "Last 2 verses of Surah Al-Baqarah (285-286) & Surah Al-Mulk",
      "adhanUrl": "https://server8.mp3quran.net/athan/01_Makkah.mp3",
    },
  ];

  void _playAdhan(String prayerName, String? url) {
    if (url == null) return;
    final audioService = context.read<AudioService>();
    audioService.playStream(
      url,
      title: "Adhan Makkah Al-Mukarramah",
      subtitle: "Call to $prayerName Prayer • الشيخ علي ملا",
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Playing Makkah Adhan for $prayerName 🕋"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prayerService = context.watch<PrayerService>();
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final times = prayerService.times.toMap();
    final current = prayerService.currentPrayer;
    final now = DateTime.now();

    return SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: [
              // Header Bar (Title + Location + Notification bell)
              Row(
                children: [
                  AnimatedBackButton(onPressed: widget.onBack),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Prayer Schedule",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
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
                                ? "Adhan & Prayer notifications enabled! 🔔"
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
              const SizedBox(height: 14),

              // Filter Tab Pills (Inspired by Image 1 Phone 3: Tour Schedule, Accomodation, Booking)
              Row(
                children: [
                  _buildTabPill(0, "Schedule (5 Prayers)", Icons.access_time_rounded, isDark),
                  const SizedBox(width: 8),
                  _buildTabPill(1, "Qaza Tracker", Icons.check_circle_outline_rounded, isDark),
                  const SizedBox(width: 8),
                  _buildTabPill(2, "Adhan & Duas", Icons.volume_up_rounded, isDark),
                ],
              ),
              const SizedBox(height: 14),

              // 7-Day Date Selector Strip (-3 to +3 days)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(22),
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
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppColors.activeNavPillGradient : null,
                          color: isSelected ? null : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
                                fontWeight: FontWeight.w800,
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
                  gradient: isDark
                      ? AppColors.purpleGoldHeroGradient
                      : AppColors.purpleGoldShiningGradient,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7E22CE).withOpacity(0.35),
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
                        const Text(
                          "NOW ACTIVE",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: AppColors.islamicGoldLight,
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
                            color: Colors.white70,
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
                            color: Colors.black.withOpacity(0.24),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Next: ${prayerService.nextPrayer} in ${prayerService.timeUntilNext}",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Title Row with Count of Completed Prayers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daily Prayers Breakdown",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    "${storage.prayersCompleted.length} of 5 Completed",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.islamicGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Accordion Itinerary of Prayers (Inspired by Image 1 Phone 3)
              Column(
                children: prayersList.map((p) {
                  final name = p["name"] as String;
                  final arabic = p["arabic"] as String;
                  final colors = (p["color"] as List<int>).map((c) => Color(c)).toList();
                  final isCurrent = current == name;
                  final time = times[name] ?? "--:--";
                  final isPrayed = storage.prayersCompleted.contains(name);
                  final isExpanded = _expandedPrayer == name;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardBg : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.islamicGold.withOpacity(0.8)
                            : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                        width: isCurrent ? 1.6 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // Collapsed Accordion Header
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedPrayer = isExpanded ? null : name;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                // Arabic Initial Badge
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: colors),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.first.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
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

                                // Name + Timing Details
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
                                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                              decoration: BoxDecoration(
                                                gradient: AppColors.goldGradient,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                "Active",
                                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Text(
                                        arabic,
                                        style: TextStyle(
                                          fontFamily: 'Amiri',
                                          fontSize: 13,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
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
                                const SizedBox(width: 10),

                                // Checkmark Toggle
                                if (name != "Sunrise")
                                  GestureDetector(
                                    onTap: () => storage.togglePrayer(name),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isPrayed
                                            ? AppColors.islamicGreen
                                            : (isDark ? Colors.white12 : const Color(0xFFF1F5F9)),
                                        border: Border.all(
                                          color: isPrayed ? AppColors.islamicGreen : Colors.grey.shade400,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isPrayed
                                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                                          : null,
                                    ),
                                  ),

                                const SizedBox(width: 8),
                                Icon(
                                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                  color: isDark ? Colors.white38 : Colors.grey,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Expanded Accordion Content (Inspired by Image 1 Phone 3 Itinerary details)
                        if (isExpanded)
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(height: 1, color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                                const SizedBox(height: 12),

                                // Rakats Info
                                Row(
                                  children: [
                                    const Icon(Icons.accessibility_new_rounded, size: 14, color: AppColors.islamicGold),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Rak'ahs: ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        p["rakats"] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Timing Description
                                Text(
                                  p["timingDesc"] as String,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    height: 1.4,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Recommended Dhikr after this prayer
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? Colors.white10 : const Color(0xFFEEF2FF),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.format_quote_rounded, size: 16, color: AppColors.islamicIndigo),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          p["dhikr"] as String,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Adhan Play Button (if applicable)
                                if (p["adhanUrl"] != null)
                                  GestureDetector(
                                    onTap: () => _playAdhan(name, p["adhanUrl"] as String?),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: colors),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.volume_up_rounded, size: 14, color: Colors.white),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Play Adhan for $name",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Sticky Bottom Full-Width Action Button (Inspired by Image 1 Phone 3 "Book a Tour")
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () {
                _playAdhan("Makkah Al-Mukarramah", "https://server8.mp3quran.net/athan/01_Makkah.mp3");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1B38) : const Color(0xFF110E1F),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mosque_rounded, color: AppColors.islamicGold, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Listen to Full Makkah Adhan 🕋",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill(int index, String label, IconData icon, bool isDark) {
    final isSelected = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.activeNavPillGradient : null,
          color: isSelected
              ? null
              : (isDark ? Colors.white.withOpacity(0.06) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
