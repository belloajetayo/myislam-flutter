import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/storage_service.dart';
import 'widgets/prayer_top_bar.dart';
import 'widgets/quick_shortcuts.dart';
import 'widgets/progress_tracker_card.dart';
import 'widgets/daily_cards_carousel.dart';
import 'widgets/islamic_feed_card.dart';
import 'widgets/islamic_calendar_card.dart';
import 'widgets/community_feed_card.dart';

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
              // Top Clean Header Bar (matching web app MobileLayout.tsx / Index.tsx)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Drawer Button (≡)
                  GestureDetector(
                    onTap: onOpenDrawer,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF2C274E) : const Color(0xFFE0E7FF),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA),
                        size: 22,
                      ),
                    ),
                  ),

                  // Dark / Light Mode Toggle Button (🌙)
                  GestureDetector(
                    onTap: () => storage.toggleDarkMode(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF2C274E) : const Color(0xFFE0E7FF),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        storage.darkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: storage.darkMode ? const Color(0xFFFBBF24) : const Color(0xFF4338CA),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 1. Next Prayer Hero Card with Islamic Date & 5 prayer pills
              PrayerTopBar(
                onTap: () => onNavigate("prayer"),
                onHijriDateTap: () => onNavigate("calendar"),
              ),

              // 2. Pillars of Islam (5 core pillar shortcuts + expandable "More v" tools)
              QuickShortcuts(onNavigate: onNavigate),
              const SizedBox(height: 16),

              // 3. Today's Progress Summary Cards (Salat, Streak, Quran, Duas)
              ProgressTrackerCard(
                onDetailsTap: () => onNavigate("progress"),
              ),
              const SizedBox(height: 16),

              // 4. Daily Inspiration (Hadith / Verse tabs, photo cards, pagination dots)
              const DailyCardsCarousel(),
              const SizedBox(height: 20),

              // 5. Daily Discover (Islamic Knowledge & Curated Articles)
              const IslamicFeedCard(),
              const SizedBox(height: 20),

              // 6. Islamic Calendar Card (Hijri Month, calendar grid, today's prayers)
              IslamicCalendarCard(
                onTap: () => onNavigate("calendar"),
              ),
              const SizedBox(height: 20),

              // 7. Daily Wisdom (Community Reflections & Discussions)
              const CommunityFeedCard(),
            ],
          ),
        ),
      ],
    );
  }
}
