import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/shining_brand_title.dart';
import '../../data/services/storage_service.dart';
import 'widgets/prayer_top_bar.dart';
import 'widgets/weekly_prayer_strip.dart';
import 'widgets/spiritual_state_selector.dart';
import 'widgets/quick_shortcuts.dart';
import 'widgets/progress_tracker_card.dart';
import 'widgets/daily_cards_carousel.dart';
import 'widgets/islamic_feed_card.dart';
import 'widgets/islamic_calendar_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(String routeName) onNavigate;
  final VoidCallback onOpenDrawer;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onOpenDrawer,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchSubmit(String query) {
    if (query.trim().isEmpty) return;
    final q = query.trim().toLowerCase();
    if (q.contains("quran") || q.contains("surah") || q.contains("ayah")) {
      widget.onNavigate("quran");
    } else if (q.contains("dua") || q.contains("adhkar") || q.contains("zikr")) {
      widget.onNavigate("duas");
    } else if (q.contains("prayer") || q.contains("salah") || q.contains("namaz")) {
      widget.onNavigate("prayer");
    } else if (q.contains("qibla") || q.contains("kaaba")) {
      widget.onNavigate("qiblah");
    } else if (q.contains("hadith")) {
      widget.onNavigate("hadith");
    } else {
      widget.onNavigate("quran");
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Decorative glowing background orbs
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0x1F6366F1)
                  : const Color(0x226366F1),
            ),
          ),
        ),
        Positioned(
          top: 360,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0x14059669)
                  : const Color(0x1E059669),
            ),
          ),
        ),

        // Main Scrollable Content
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            children: [
              // Top Header Bar (Inspired by Image 1, 3, 5)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Drawer Button
                  GestureDetector(
                    onTap: widget.onOpenDrawer,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0x406366F1) : const Color(0xFFC7D2FE),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.menu_rounded, color: AppColors.islamicIndigo, size: 22),
                    ),
                  ),

                  // App Brand Title
                  const ShiningBrandTitle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),

                  // Actions: Notifications + Dark Mode
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => storage.toggleDarkMode(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            storage.darkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: storage.darkMode ? const Color(0xFFFBBF24) : AppColors.islamicIndigo,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Greeting & Subtitle (Inspired by Image 1 & 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Assalamu Alaikum",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text("✨", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Your daily spiritual companion and guide",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => widget.onNavigate("profile"),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGoldShiningGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7E22CE).withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "🕋",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search Input Pill (Inspired by Image 1 & Image 2)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _handleSearchSubmit,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search Quran, Duas, Prayers, Hadiths...",
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.islamicIndigo,
                      size: 20,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => _handleSearchSubmit(_searchController.text),
                      child: Container(
                        margin: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.islamicIndigo.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          size: 16,
                          color: AppColors.islamicIndigo,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 1. Next Prayer Hero Card with Countdown & Adhan Stream
              PrayerTopBar(
                onTap: () => widget.onNavigate("prayer"),
                onHijriDateTap: () => widget.onNavigate("calendar"),
              ),

              // 2. Interactive 7-Day Prayer Calendar Strip (Inspired by Images 3 & 4)
              WeeklyPrayerStrip(
                onOpenPrayerScreen: () => widget.onNavigate("prayer"),
              ),
              const SizedBox(height: 18),

              // 3. Spiritual State Check-in / "How is your heart today?" (Inspired by Image 5)
              SpiritualStateSelector(
                onNavigate: widget.onNavigate,
              ),
              const SizedBox(height: 20),

              // 4. Quick Utilities 6-Grid Pastel Squircles (Inspired by Images 2 & 5)
              QuickShortcuts(
                onNavigate: widget.onNavigate,
              ),
              const SizedBox(height: 20),

              // 5. Today's Spiritual Goal Progress Ring (Inspired by Image 3)
              ProgressTrackerCard(
                onDetailsTap: () => widget.onNavigate("profile"),
              ),
              const SizedBox(height: 20),

              // 6. Featured Spiritual Journey / Daily Cards Carousel
              const DailyCardsCarousel(),
              const SizedBox(height: 20),

              // 7. Discover Feed Articles
              const IslamicFeedCard(),
              const SizedBox(height: 20),

              // 8. Islamic Calendar Card
              IslamicCalendarCard(
                onTap: () => widget.onNavigate("calendar"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
