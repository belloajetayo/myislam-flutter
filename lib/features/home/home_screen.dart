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
import 'widgets/mia_assistant_sheet.dart';

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

                  // App Brand Title
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: AppColors.goldGradient,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.mosque_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "MyIslam",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
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

        // Floating MIA Assistant Button
        Positioned(
          bottom: 24,
          right: 20,
          child: GestureDetector(
            onTap: () => MIAAssistantSheet.show(context),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF38BDF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 26),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF43F5E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
