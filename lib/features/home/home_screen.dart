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
import 'widgets/community_feed_card.dart';

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
        // Decorative glowing background orbs (from MobileLayout.tsx)
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0xFF6366F1).withOpacity(0.12)
                  : const Color(0xFFC7D2FE).withOpacity(0.35),
            ),
          ),
        ),
        Positioned(
          top: 380,
          left: -60,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0xFF38BDF8).withOpacity(0.08)
                  : const Color(0xFFBAE6FD).withOpacity(0.35),
            ),
          ),
        ),

        // Main Scrollable Content
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            children: [
              // Top Header Bar (from NavHeader.tsx in belloajetayo/myislam)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Logo & Subtitle
                  Row(
                    children: [
                      // Menu Drawer Button
                      GestureDetector(
                        onTap: widget.onOpenDrawer,
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2C274E) : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.menu_rounded,
                            color: isDark ? AppColors.primaryGoldLight : AppColors.islamicIndigo,
                            size: 20,
                          ),
                        ),
                      ),

                      // Logo Icon Badge (gradient-primary with "م")
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryBrandGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGold.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "م",
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // App Name & Tagline
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShiningBrandTitle(
                            text: "MyIslam",
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                          Text(
                            "Faith & Practice",
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Actions: Theme toggle, Notification bell, Profile
                  Row(
                    children: [
                      // Dark / Light Mode Toggle
                      GestureDetector(
                        onTap: () => storage.toggleDarkMode(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2C274E) : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            storage.darkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: storage.darkMode ? AppColors.primaryGoldLight : AppColors.islamicIndigo,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Notification Bell with indicator dot
                      GestureDetector(
                        onTap: () => widget.onNavigate("prayer"),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2C274E) : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                color: isDark ? Colors.white70 : const Color(0xFF475569),
                                size: 19,
                              ),
                              Positioned(
                                top: 9,
                                right: 9,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryGold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
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

              // 5. Today's Spiritual Goal Progress (Progress.tsx)
              ProgressTrackerCard(
                onDetailsTap: () => widget.onNavigate("progress"),
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
              const SizedBox(height: 20),

              // 9. Community Feed Reflections & Discussions (CommunityFeed.tsx)
              const CommunityFeedCard(),
            ],
          ),
        ),
      ],
    );
  }
}
