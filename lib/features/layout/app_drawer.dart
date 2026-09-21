import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/shining_brand_title.dart';
import '../../data/services/storage_service.dart';
import '../ai_companion/myislam_ai_sheet.dart';

class AppDrawer extends StatefulWidget {
  final Function(String routeName) onNavigate;

  const AppDrawer({super.key, required this.onNavigate});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _islamicToolsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkBgStart : AppColors.lightBgStart,
      child: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 24),
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.purpleGoldHeroGradient
                  : const LinearGradient(
                      colors: [Color(0xFF2E1A47), Color(0xFF4A2875), Color(0xFF1F1133)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShiningBrandTitle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
                SizedBox(height: 4),
                Text(
                  "Assalamu Alaikum 🌙 • Your Islamic Companion",
                  style: TextStyle(color: Color(0xFFE9D5FF), fontSize: 11.5),
                ),
              ],
            ),
          ),

          // Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              children: [
                // Highlighted MyIslam AI Companion Button
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E1065), Color(0xFF1E1B4B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.islamicGold.withOpacity(0.6), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.islamicPurple.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        gradient: AppColors.purpleGoldShiningGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                    ),
                    title: const Text(
                      "MyIslam AI Guide",
                      style: TextStyle(
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    subtitle: const Text(
                      "Ask questions & explore app tour",
                      style: TextStyle(color: Colors.white70, fontSize: 10.5),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.goldWarm, size: 13),
                    onTap: () {
                      Navigator.pop(context);
                      MyIslamAiSheet.show(context, onNavigate: widget.onNavigate);
                    },
                  ),
                ),

                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: "Home",
                  colors: [const Color(0xFF6366F1), const Color(0xFF3B82F6)],
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigate("home");
                  },
                ),
                _buildNavItem(
                  icon: Icons.access_time_filled_rounded,
                  label: "Prayer Times",
                  colors: [const Color(0xFF3B82F6), const Color(0xFF06B6D4)],
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigate("prayer");
                  },
                ),
                _buildNavItem(
                  icon: Icons.explore_rounded,
                  label: "Qiblah",
                  colors: [const Color(0xFF06B6D4), const Color(0xFF14B8A6)],
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigate("qiblah");
                  },
                ),
                _buildNavItem(
                  icon: Icons.menu_book_rounded,
                  label: "Quran",
                  colors: [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigate("quran");
                  },
                ),
                _buildNavItem(
                  icon: Icons.favorite_rounded,
                  label: "Donate",
                  colors: [const Color(0xFFF43F5E), const Color(0xFFEC4899)],
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigate("donate");
                  },
                ),

                const Divider(height: 24, thickness: 0.5),

                // Islamic Tools Collapsible
                InkWell(
                  onTap: () {
                    setState(() {
                      _islamicToolsExpanded = !_islamicToolsExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Islamic Tools",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Icon(
                          _islamicToolsExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                if (_islamicToolsExpanded) ...[
                  _buildSubItem("Hijri Calendar", Icons.calendar_month_rounded, [0xFFD97706, 0xFFF59E0B], () {
                    Navigator.pop(context);
                    widget.onNavigate("calendar");
                  }),
                  _buildSubItem("Digital Tasbih", Icons.fingerprint_rounded, [0xFF059669, 0xFF10B981], () {
                    Navigator.pop(context);
                    widget.onNavigate("tasbih");
                  }),
                  _buildSubItem("Duas Library", Icons.bookmark_rounded, [0xFF14B8A6, 0xFF10B981], () {
                    Navigator.pop(context);
                    widget.onNavigate("duas");
                  }),
                  _buildSubItem("Zakat Calculator", Icons.volunteer_activism_rounded, [0xFFF59E0B, 0xFFD97706], () {
                    Navigator.pop(context);
                    widget.onNavigate("zakat");
                  }),
                  _buildSubItem("Fasting Tracker", Icons.nightlight_round, [0xFF8B5CF6, 0xFF7C3AED], () {
                    Navigator.pop(context);
                    widget.onNavigate("fasting");
                  }),
                  _buildSubItem("Hajj Guide", Icons.location_on_rounded, [0xFFF43F5E, 0xFFBE123C], () {
                    Navigator.pop(context);
                    widget.onNavigate("hajj");
                  }),
                  _buildSubItem("Stories of Prophets", Icons.auto_stories_rounded, [0xFF7E22CE, 0xFFA855F7], () {
                    Navigator.pop(context);
                    widget.onNavigate("prophets");
                  }),
                  _buildSubItem("Hadith Explorer", Icons.menu_book_rounded, [0xFF0EA5E9, 0xFF6366F1], () {
                    Navigator.pop(context);
                    widget.onNavigate("hadith");
                  }),
                  _buildSubItem("Podcasts & Radio", Icons.headphones_rounded, [0xFF3B82F6, 0xFF1D4ED8], () {
                    Navigator.pop(context);
                    widget.onNavigate("podcasts");
                  }),
                ],

                const Divider(height: 24, thickness: 0.5),

                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: "Profile & Progress",
                  colors: [const Color(0xFF64748B), const Color(0xFF475569)],
                  onTap: () {
                    Navigator.pop(context);
                    widget.onNavigate("profile");
                  },
                ),

                // Dark Mode Switch
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  leading: Icon(
                    storage.darkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: storage.darkMode ? const Color(0xFFFBBF24) : AppColors.islamicIndigo,
                  ),
                  title: const Text("Dark Theme", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: Switch(
                    value: storage.darkMode,
                    activeColor: AppColors.islamicGold,
                    onChanged: (_) => storage.toggleDarkMode(),
                  ),
                ),
              ],
            ),
          ),

          // Footer version banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Text(
                  "MyIslam App v1.0",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.islamicIndigo),
                ),
                SizedBox(height: 2),
                Text(
                  "Your complete Islamic companion 🕌",
                  style: TextStyle(fontSize: 10, color: Color(0xFF818CF8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildSubItem(String label, IconData icon, List<int> colors, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 4, bottom: 4),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors.map((c) => Color(c)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 15),
        ),
        title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
