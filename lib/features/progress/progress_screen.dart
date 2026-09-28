import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/services/storage_service.dart';

class ProgressScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ProgressScreen({super.key, required this.onBack});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  static const List<String> prayers = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];

  static const Map<String, List<Color>> prayerColors = {
    "Fajr": [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
    "Dhuhr": [Color(0xFFF59E0B), Color(0xFFEA580C)],
    "Asr": [Color(0xFF0EA5E9), Color(0xFF2563EB)],
    "Maghrib": [Color(0xFFF43F5E), Color(0xFFDB2777)],
    "Isha": [Color(0xFF4F46E5), Color(0xFF7C3AED)],
  };

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final prayersCount = storage.prayersCompleted.length;
    final prayerPercent = (prayersCount / 5.0).clamp(0.0, 1.0);
    final quranPercent = (storage.quranPagesRead / 20.0).clamp(0.0, 1.0);
    final streakPercent = (storage.streak / 30.0).clamp(0.0, 1.0);

    final now = DateTime.now();
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    final dateStr = "${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgStart : AppColors.lightBgStart,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            // Header Bar
            Row(
              children: [
                AnimatedBackButton(onPressed: widget.onBack),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.trending_up_rounded, color: AppColors.islamicIndigo, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "Daily Progress",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Top 3 Stat Cards (from Progress.tsx)
            Row(
              children: [
                _buildStatCard(
                  label: "Prayers",
                  value: "$prayersCount/5",
                  icon: Icons.track_changes_rounded,
                  colors: const [Color(0xFF6366F1), Color(0xFF2563EB)],
                  progress: prayerPercent,
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _buildStatCard(
                  label: "Streak",
                  value: "${storage.streak}d",
                  icon: Icons.local_fire_department_rounded,
                  colors: const [Color(0xFFF97316), Color(0xFFEF4444)],
                  progress: streakPercent,
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _buildStatCard(
                  label: "Quran",
                  value: "${storage.quranPagesRead}pg",
                  icon: Icons.menu_book_rounded,
                  colors: const [Color(0xFF10B981), Color(0xFF0D9488)],
                  progress: quranPercent,
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Today's Prayers Checklist Card
            Container(
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
                children: [
                  // Title bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, color: AppColors.islamicIndigo, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Today's Prayers",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: prayersCount == 5
                                ? const Color(0xFF10B981).withOpacity(0.15)
                                : AppColors.islamicIndigo.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            prayersCount == 5 ? "✅ Complete!" : "$prayersCount / 5 Done",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: prayersCount == 5 ? const Color(0xFF10B981) : AppColors.islamicIndigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

                  // Prayers list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: prayers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final name = prayers[index];
                      final isDone = storage.prayersCompleted.contains(name);
                      final grad = prayerColors[name] ?? [const Color(0xFF6366F1), const Color(0xFF2563EB)];

                      return GestureDetector(
                        onTap: () => storage.togglePrayer(name),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDone
                                ? (isDark ? const Color(0xFF6366F1).withOpacity(0.15) : const Color(0xFFEEF2FF))
                                : (isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDone
                                  ? AppColors.islamicIndigo.withOpacity(0.4)
                                  : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: grad),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: grad.first.withOpacity(0.3),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        name[0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: isDone ? FontWeight.bold : FontWeight.w600,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  gradient: isDone ? AppColors.activeNavPillGradient : null,
                                  color: isDone ? null : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: isDone
                                      ? null
                                      : Border.all(
                                          color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                                          width: 2,
                                        ),
                                ),
                                child: isDone
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Quran Reading Tracker Card
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
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF0D9488)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Quran Reading",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                "Target: 20 pages/day (1 Juz)",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "${storage.quranPagesRead} / 20 pg",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: quranPercent,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Log Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Log read pages today:",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          _buildLogButton("-1", () {
                            if (storage.quranPagesRead > 0) {
                              storage.addQuranPages(-1);
                            }
                          }, isDark),
                          const SizedBox(width: 8),
                          _buildLogButton("+1", () => storage.addQuranPages(1), isDark),
                          const SizedBox(width: 8),
                          _buildLogButton("+5", () => storage.addQuranPages(5), isDark, isHighlight: true),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required List<Color> colors,
    required double progress,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withOpacity(0.35),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(colors.first),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogButton(String text, VoidCallback onTap, bool isDark, {bool isHighlight = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isHighlight
              ? const Color(0xFF10B981)
              : (isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: isHighlight
              ? null
              : Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF334155)),
          ),
        ),
      ),
    );
  }
}
