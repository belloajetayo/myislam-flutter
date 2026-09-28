import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WelcomeOnboardingModal extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeOnboardingModal({super.key, required this.onGetStarted});

  static void show(BuildContext context, {required VoidCallback onGetStarted}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WelcomeOnboardingModal(
        onGetStarted: () {
          Navigator.of(ctx).pop();
          onGetStarted();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131028) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        border: Border.all(
          color: isDark ? const Color(0xFF382F5E) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),

          // Illustration Badge
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.purpleGoldShiningGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7E22CE).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text("🕋", style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 18),

          // Headline (Inspired by Image 4 Screen 1)
          Text(
            "Bismillah — Welcome to MyIslam!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            "Your modern spiritual companion, designed to elevate your daily Salah, Quran recitation, Duas, and Islamic knowledge.",
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),

          // 4 Feature Pillars
          _buildFeatureRow(
            Icons.menu_book_rounded,
            "Holy Quran & Audio",
            "114 Surahs with high quality recitations",
            const Color(0xFF10B981),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildFeatureRow(
            Icons.access_time_filled_rounded,
            "Accurate Prayer Times",
            "Interactive schedule with Adhan notifications",
            const Color(0xFF0EA5E9),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildFeatureRow(
            Icons.explore_rounded,
            "Qiblah Direction Compass",
            "Real-time sensor pointer directly to Kaaba",
            const Color(0xFFF59E0B),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildFeatureRow(
            Icons.auto_awesome_rounded,
            "MyIslam AI Companion",
            "Ask questions & get authentic Islamic guidance",
            const Color(0xFF8B5CF6),
            isDark,
          ),
          const SizedBox(height: 26),

          // Swipe / Action Button (Inspired by Image 4 "Continue >>>")
          GestureDetector(
            onTap: onGetStarted,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: AppColors.purpleGoldShiningGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7E22CE).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Start Your Spiritual Journey",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
