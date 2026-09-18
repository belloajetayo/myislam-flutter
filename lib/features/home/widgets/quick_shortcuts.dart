import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QuickShortcuts extends StatelessWidget {
  final Function(String routeName) onNavigate;

  const QuickShortcuts({super.key, required this.onNavigate});

  static final List<Map<String, dynamic>> _tools = [
    {
      "label": "Quran",
      "arabic": "القرآن",
      "icon": Icons.menu_book_rounded,
      "gradient": AppColors.purpleGoldShiningGradient,
      "route": "quran",
      "badge": "Mushaf",
    },
    {
      "label": "Tasbih",
      "arabic": "السبحة",
      "icon": Icons.fingerprint_rounded,
      "gradient": AppColors.tasbihGradient,
      "route": "tasbih",
      "badge": "Dhikr",
    },
    {
      "label": "Duas",
      "arabic": "الأدعية",
      "icon": Icons.bookmark_added_rounded,
      "gradient": const LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF14B8A6)]),
      "route": "duas",
    },
    {
      "label": "Qiblah",
      "arabic": "القبلة",
      "icon": Icons.explore_rounded,
      "gradient": const LinearGradient(colors: [Color(0xFFD97706), Color(0xFFF59E0B)]),
      "route": "qiblah",
    },
    {
      "label": "Prayers",
      "arabic": "الصلوات",
      "icon": Icons.access_time_filled_rounded,
      "gradient": const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)]),
      "route": "prayer",
    },
    {
      "label": "Fasting",
      "arabic": "الصيام",
      "icon": Icons.nightlight_round,
      "gradient": const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)]),
      "route": "fasting",
    },
    {
      "label": "Zakat",
      "arabic": "الزكاة",
      "icon": Icons.volunteer_activism_rounded,
      "gradient": const LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFF97316)]),
      "route": "zakat",
    },
    {
      "label": "Radio",
      "arabic": "إذاعة",
      "icon": Icons.headphones_rounded,
      "gradient": const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]),
      "route": "podcasts",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Islamic Utilities",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.islamicPurple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "MyIslam Suite",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.islamicPurple),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 8-Tool Grid (2 rows of 4)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final tool = _tools[index];
            final gradient = tool["gradient"] as LinearGradient;
            final badge = tool["badge"] as String?;

            return GestureDetector(
              onTap: () => onNavigate(tool["route"] as String),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: gradient.colors.first.withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(tool["icon"] as IconData, color: Colors.white, size: 22),
                        ),
                        if (badge != null)
                          Positioned(
                            top: -4,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      tool["label"] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      tool["arabic"] as String,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 10,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
