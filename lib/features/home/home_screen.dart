import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/shining_brand_title.dart';
import '../../data/services/storage_service.dart';
import 'widgets/prayer_top_bar.dart';
import 'widgets/quick_shortcuts.dart';
import 'widgets/progress_tracker_card.dart';
import 'widgets/daily_cards_carousel.dart';
import 'widgets/islamic_feed_card.dart';
import 'widgets/islamic_calendar_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(String routeName) onNavigate;
  final VoidCallback onOpenDrawer;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onOpenDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Decorative background glowing orbs
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0x1F6366F1)
                  : const Color(0x286366F1),
            ),
          ),
        ),
        Positioned(
          top: 300,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0x140EA5E9)
                  : const Color(0x1F0EA5E9),
            ),
          ),
        ),

        // Main Scrollable Content
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              // Custom Header Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Button
                  GestureDetector(
                    onTap: onOpenDrawer,
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

                  // App Brand Title - Shining Purple Gold Gradient (No logo)
                  const ShiningBrandTitle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),

                  // Dark Mode Switch Button
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

              const SizedBox(height: 16),

              // Prayer Top Bar
              PrayerTopBar(
                onTap: () => onNavigate("prayer"),
              ),

              // Quick Shortcuts (Pillars of Islam)
              QuickShortcuts(
                onNavigate: onNavigate,
              ),

              const SizedBox(height: 18),

              // Today's Progress Tracker
              ProgressTrackerCard(
                onDetailsTap: () => onNavigate("profile"),
              ),

              const SizedBox(height: 20),

              // Daily Hadith & Verse Carousel
              const DailyCardsCarousel(),

              const SizedBox(height: 20),

              // Daily Discover Articles Feed
              const IslamicFeedCard(),

              const SizedBox(height: 20),

              // Islamic Calendar Card
              const IslamicCalendarCard(),
            ],
          ),
        ),
      ],
    );
  }
}
