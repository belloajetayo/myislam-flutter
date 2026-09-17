import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/storage_service.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onBack;

  const ProfileScreen({super.key, required this.onBack});

  static const List<Map<String, dynamic>> badges = [
    {"name": "First Prayer", "desc": "Logged your first prayer in MyIslam", "icon": Icons.track_changes_rounded, "earned": true},
    {"name": "7-Day Streak", "desc": "Maintained 7 consecutive days of prayer", "icon": Icons.local_fire_department_rounded, "earned": true},
    {"name": "Quran Explorer", "desc": "Read multiple Surahs with translation", "icon": Icons.menu_book_rounded, "earned": true},
    {"name": "Adhkar Devotee", "desc": "Recited 50+ morning and evening supplications", "icon": Icons.volunteer_activism_rounded, "earned": false},
  ];

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          // Header Bar
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, size: 20),
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                "Profile & Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // User Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)])
                  : AppColors.heroPrayerGradient,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: AppColors.islamicIndigo.withOpacity(0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Text("BA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bello Ajetayo",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "MyIslam Companion Member",
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "${storage.streak} Days Active Streak",
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats Overview
          Row(
            children: [
              _buildStatBox("Salat Today", "${storage.prayersCompleted.length}/5", AppColors.salatGradient, isDark),
              const SizedBox(width: 8),
              _buildStatBox("Quran Pages", "${storage.quranPagesRead} pg", AppColors.quranGradient, isDark),
              const SizedBox(width: 8),
              _buildStatBox("Duas Read", "${storage.duasRead}", AppColors.sawmGradient, isDark),
            ],
          ),

          const SizedBox(height: 24),

          // Spiritual Achievements & Badges
          const Text("Spiritual Milestones", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Column(
            children: badges.map((b) {
              final earned = b["earned"] as bool;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: earned ? AppColors.islamicGold.withOpacity(0.4) : (isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: earned ? AppColors.goldGradient : null,
                        color: earned ? null : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(b["icon"] as IconData, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b["name"] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: earned ? null : Colors.grey,
                            ),
                          ),
                          Text(
                            b["desc"] as String,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (earned)
                      const Icon(Icons.verified_rounded, color: AppColors.islamicGold, size: 22)
                    else
                      const Icon(Icons.lock_rounded, color: Colors.grey, size: 18),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // App Settings Tile
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.dark_mode_rounded, color: AppColors.islamicGold),
            title: const Text("Dark Theme Mode", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            trailing: Switch(
              value: storage.darkMode,
              activeColor: AppColors.islamicGold,
              onChanged: (_) => storage.toggleDarkMode(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, LinearGradient gradient, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEF2FF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
