import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';

class HajjScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HajjScreen({super.key, required this.onBack});

  @override
  State<HajjScreen> createState() => _HajjScreenState();
}

class _HajjScreenState extends State<HajjScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _checkedItems = {};

  static const List<Map<String, String>> hajjSteps = [
    {
      "day": "Day 1 (8th Dhul Hijjah)",
      "title": "Enter Ihram & Travel to Mina",
      "desc": "Wear the two white Ihram garments, formulate the intention (Niyyah), and stay in Mina praying all 5 prayers.",
    },
    {
      "day": "Day 2 (9th Dhul Hijjah)",
      "title": "Day of Arafah (The Peak)",
      "desc": "Travel to plains of Arafah after Fajr. Stand before Allah in earnest prayer & repentance until sunset.",
    },
    {
      "day": "Night of 9th - 10th",
      "title": "Muzdalifah Night",
      "desc": "Sleep under the open sky at Muzdalifah, combine Maghrib & Isha, and collect 49-70 small pebbles.",
    },
    {
      "day": "Day 3 (10th Dhul Hijjah)",
      "title": "Eid, Jamarat & Tawaf al-Ifadah",
      "desc": "Pebble throwing at Jamarat al-Aqaba, animal sacrifice (Qurbani), shave or trim hair (Tahallul), and Tawaf.",
    },
    {
      "day": "Days 4-6 (11th-13th)",
      "title": "Days of Tashreeq in Mina",
      "desc": "Stone all three pillars daily after Dhuhr, stay in Mina, and perform Farewell Tawaf (Tawaf al-Wida) before leaving.",
    },
  ];

  static const List<String> ihramDos = [
    "Formulate sincere intention for Allah",
    "Keep patient during heavy crowds",
    "Recite Talbiyah frequently",
    "Help elderly and fellow pilgrims",
  ];

  static const List<String> ihramDonts = [
    "No arguing, anger, or vulgar speech",
    "No cutting hair or clipping nails",
    "No perfumes or scented toiletries",
    "No covering head for men or face for women",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                AnimatedBackButton(onPressed: widget.onBack),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hajj & Umrah Guide",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                    ),
                    Text(
                      "The Sacred Pilgrimage (Fifth Pillar)",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: AppColors.islamicGold,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.islamicGold,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Rituals Guide"),
              Tab(text: "Dos & Don'ts"),
              Tab(text: "Checklist"),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Rituals Guide
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  children: [
                    // Talbiyah Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroPrayerGradient,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Column(
                        children: [
                          Text("TALBIYAH", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text(
                            "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ",
                            style: TextStyle(fontFamily: 'Amiri', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "\"Here I am, O Allah, here I am. Here I am, You have no partner, here I am.\"",
                            style: TextStyle(color: Colors.white, fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Day by Day Steps
                    ...hajjSteps.map((step) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEF2FF)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step["day"]!,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              step["title"]!,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              step["desc"]!,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.45,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),

                // 2. Dos & Don'ts
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  children: [
                    const Text("Requirements (Dos)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF10B981))),
                    const SizedBox(height: 8),
                    ...ihramDos.map((d) => _buildCheckTile(d, true, isDark)),
                    const SizedBox(height: 16),
                    const Text("Prohibitions (Don'ts)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFEF4444))),
                    const SizedBox(height: 8),
                    ...ihramDonts.map((d) => _buildCheckTile(d, false, isDark)),
                  ],
                ),

                // 3. Checklist
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  children: [
                    // Interactive Progress Card
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGoldShiningGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.islamicGold.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Packing Progress",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                "${_checkedItems.length} / 10 Packed",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (_checkedItems.length / 10).clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildChecklistCategory("Essential Documents", [
                      "Passport with valid Hajj/Umrah visa",
                      "Vaccination certificates (Meningitis, etc.)",
                      "Emergency contacts & agency contacts",
                    ], isDark),
                    _buildChecklistCategory("Ihram & Clothing", [
                      "2 sets of white Ihram towels (men)",
                      "Modest comfortable Abayas / loose clothing (women)",
                      "Comfortable walking flip-flops / sandals",
                      "Waist pouch or neck pouch for valuables",
                    ], isDark),
                    _buildChecklistCategory("Spiritual Items", [
                      "Pocket Quran or downloaded Quran app",
                      "Authentic Duas book (Hisnul Muslim)",
                      "Digital tasbeeh counter",
                    ], isDark),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckTile(String text, bool isDo, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(
            isDo ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isDo ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildChecklistCategory(String title, List<String> items, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEF2FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.islamicGold)),
          const SizedBox(height: 8),
          ...items.map((i) {
            final isChecked = _checkedItems.contains(i);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isChecked) {
                    _checkedItems.remove(i);
                  } else {
                    _checkedItems.add(i);
                  }
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Row(
                  children: [
                    Icon(
                      isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: isChecked ? AppColors.islamicGold : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        i,
                        style: TextStyle(
                          fontSize: 12.5,
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked ? Colors.grey : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
