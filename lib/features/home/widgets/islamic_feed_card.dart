import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class IslamicFeedCard extends StatelessWidget {
  const IslamicFeedCard({super.key});

  static const List<Map<String, String>> articles = [
    {
      "title": "The Power & Barakah of Tahajjud",
      "category": "Spirituality",
      "readTime": "3 min read",
      "icon": "✨",
      "desc": "How standing in the last third of the night brings peace and answered prayers to the believer.",
    },
    {
      "title": "Consistency in Daily Adhkar",
      "category": "Remembrance",
      "readTime": "4 min read",
      "icon": "📿",
      "desc": "Morning and evening remembrances act as an impenetrable spiritual shield for your day.",
    },
    {
      "title": "Preparing Your Heart for Ramadan",
      "category": "Ramadan",
      "readTime": "5 min read",
      "icon": "🌙",
      "desc": "Practical daily steps in Sha'ban to arrive at the holy month with momentum and focus.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Daily Discover",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.islamicGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Fresh",
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal Feed Carousel
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final art = articles[index];

              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.islamicIndigo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            art["category"]!,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.islamicIndigo),
                          ),
                        ),
                        Text(
                          art["readTime"]!,
                          style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                    Text(
                      art["title"]!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      art["desc"]!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
