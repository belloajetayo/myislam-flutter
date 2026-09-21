import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/models/prophet_model.dart';
import '../../data/sources/local_prophets_data.dart';
import '../ai_companion/widgets/3d/holographic_3d_card.dart';
import 'prophet_detail_screen.dart';

class ProphetsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ProphetsScreen({super.key, required this.onBack});

  @override
  State<ProphetsScreen> createState() => _ProphetsScreenState();
}

class _ProphetsScreenState extends State<ProphetsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedEra = "All";

  static const List<String> _eras = [
    "All",
    "Early Humanity",
    "Mesopotamia & Levant",
    "Egypt & Banu Israel",
    "Arabian Peninsula",
    "Final Prophet",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProphetItem> get _filteredProphets {
    return LocalProphetsData.allProphets.where((p) {
      final matchesEra = _selectedEra == "All" || p.era.toLowerCase().contains(_selectedEra.toLowerCase());
      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          p.nameEnglish.toLowerCase().contains(q) ||
          p.nameArabic.contains(q) ||
          p.title.toLowerCase().contains(q) ||
          p.era.toLowerCase().contains(q) ||
          p.keySurahs.toLowerCase().contains(q) ||
          p.miracles.any((m) => m.toLowerCase().contains(q));
      return matchesEra && matchesSearch;
    }).toList();
  }

  void _openDetail(ProphetItem prophet) {
    final all = LocalProphetsData.allProphets;
    final index = all.indexWhere((p) => p.id == prophet.id);
    final prev = index > 0 ? all[index - 1] : null;
    final next = index < all.length - 1 ? all[index + 1] : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProphetDetailScreen(
          prophet: prophet,
          previousProphet: prev,
          nextProphet: next,
          onSelectProphet: (newProphet) {
            _openDetail(newProphet);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prophets = _filteredProphets;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgStart : AppColors.lightBgStart,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  AnimatedBackButton(
                    onPressed: widget.onBack,
                    tooltip: "Back to Home",
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Stories of the Prophets",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: AppColors.purpleGoldShiningGradient,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "25",
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "قَصَصُ ٱلْأَنْبِيَاءِ عَلَيْهِمُ ٱلسَّلَامُ",
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 13,
                            color: AppColors.islamicGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar & Filter Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Search Input
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardBg : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search Prophet, miracle, era, or Surah...",
                        hintStyle: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 13.5,
                        ),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.islamicGold, size: 22),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = "");
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Era Filter Chips
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _eras.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final era = _eras[index];
                        final isSelected = _selectedEra == era;

                        return ChoiceChip(
                          label: Text(
                            era,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.islamicPurpleDeep,
                          backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.islamicGold
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onSelected: (val) {
                            setState(() => _selectedEra = era);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Results Counter & Quick stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Showing ${prophets.length} of 25 Prophets",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, size: 13, color: AppColors.astraSky),
                      const SizedBox(width: 4),
                      Text(
                        "Quranic Duas Included",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.astraSky,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // List of Prophets with Holographic 3D Tilt Cards
            Expanded(
              child: prophets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_stories_outlined,
                            size: 48,
                            color: isDark ? Colors.white30 : Colors.black26,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No Prophets found matching '$_searchQuery'",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      itemCount: prophets.length,
                      itemBuilder: (context, index) {
                        final prophet = prophets[index];
                        return _buildProphetCard(prophet, isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProphetCard(ProphetItem prophet, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Holographic3dCard(
        maxRotation: 0.10,
        borderRadius: 20,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.35) : AppColors.islamicPurple.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppColors.darkCardBg,
                  const Color(0xFF1F1A3A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFFFAFAFE),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openDetail(prophet),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Number, Name, Arabic Calligraphy
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Badge
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGoldShiningGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "#${prophet.order.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // English Name & Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prophet.nameEnglish,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            prophet.title,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.islamicGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arabic Name Calligraphy
                    Text(
                      prophet.nameArabic,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldLight : AppColors.islamicGoldDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Summary snippet
                Text(
                  prophet.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Divider line
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
                const SizedBox(height: 10),

                // Bottom Badges: Mentions, Era, Primary Miracle
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.astraSky.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.menu_book_rounded, size: 12, color: AppColors.astraSky),
                          const SizedBox(width: 4),
                          Text(
                            "${prophet.quranMentions}x Quran",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.astraSky,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.islamicPurple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        prophet.era,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.islamicPurple,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Read Story",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.islamicGold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.islamicGold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
