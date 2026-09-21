import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/models/hadith_model.dart';
import '../../data/sources/local_hadiths_data.dart';
import '../ai_companion/widgets/3d/holographic_3d_card.dart';

class HadithsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HadithsScreen({super.key, required this.onBack});

  @override
  State<HadithsScreen> createState() => _HadithsScreenState();
}

class _HadithsScreenState extends State<HadithsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final Set<int> _bookmarkedIds = {};
  final Set<int> _expandedSharh = {};
  int _selectedThematicCategory = 1; // Default to Category ID 1 (Foundations)
  double _arabicFontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _copyHadith(HadithItem hadith) {
    final text =
        "Hadith: ${hadith.title} (#${hadith.number})\n\n${hadith.arabic}\n\nTranslation:\n\"${hadith.translation}\"\n\nNarrated by: ${hadith.narrator}\nSource: ${hadith.source} [${hadith.grade}]\n\nExplanation:\n${hadith.explanation}\n\nShared via MyIslam App";
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.islamicGold, size: 20),
            const SizedBox(width: 10),
            Text("Hadith #${hadith.number} copied to clipboard"),
          ],
        ),
        backgroundColor: const Color(0xFF1E1B4B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleBookmark(int number) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_bookmarkedIds.contains(number)) {
        _bookmarkedIds.remove(number);
      } else {
        _bookmarkedIds.add(number);
      }
    });
  }

  List<HadithItem> get _allHadiths {
    final list = <HadithItem>[...LocalHadithsData.nawawi40Hadiths];
    for (final cat in LocalHadithsData.thematicCategories) {
      for (final h in cat.hadiths) {
        if (!list.any((existing) => existing.number == h.number)) {
          list.add(h);
        }
      }
    }
    return list;
  }

  List<HadithItem> _filterList(List<HadithItem> items) {
    final q = _searchQuery.toLowerCase().trim();
    if (q.isEmpty) return items;
    return items.where((h) {
      return h.title.toLowerCase().contains(q) ||
          h.arabic.contains(q) ||
          h.translation.toLowerCase().contains(q) ||
          h.narrator.toLowerCase().contains(q) ||
          h.source.toLowerCase().contains(q) ||
          h.topic.toLowerCase().contains(q) ||
          h.explanation.toLowerCase().contains(q) ||
          h.number.toString() == q;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgStart : AppColors.lightBgStart,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Title Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                              "Hadith Explorer",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.astraSky, AppColors.astraPurple],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Authentic",
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "مَوْسُوعَةُ ٱلْحَدِيثِ ٱلشَّرِيفِ",
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
                  // Font size adjuster popup
                  IconButton(
                    icon: const Icon(Icons.format_size_rounded, color: AppColors.islamicGold),
                    tooltip: "Adjust Arabic Font Size",
                    onPressed: () {
                      _showFontSizeDialog(context, isDark);
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
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
                    hintText: "Search by number, narrator, source, keywords...",
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
            ),
            const SizedBox(height: 8),

            // Astra Trilateral Style TabBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: AppColors.purpleGoldShiningGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.5),
                tabs: const [
                  Tab(text: "40 Nawawi"),
                  Tab(text: "Thematic"),
                  Tab(text: "Bookmarks"),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  // 1. 40 Hadith Nawawi Tab
                  _buildNawawiTab(isDark),

                  // 2. Thematic Collections Tab
                  _buildThematicTab(isDark),

                  // 3. Bookmarks Tab
                  _buildBookmarksTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNawawiTab(bool isDark) {
    final list = _filterList(LocalHadithsData.nawawi40Hadiths);

    return Column(
      children: [
        // Subtitle badge
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الأَرْبَعِينَ النَّوَوِيَّة • Complete Collection",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.goldLight : AppColors.islamicGoldDark,
                ),
              ),
              Text(
                "${list.length} Hadiths",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: list.isEmpty
              ? _buildEmptyState("No Hadiths match your search in 40 Nawawi", isDark)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _buildHadithCard(list[index], isDark);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildThematicTab(bool isDark) {
    final categories = LocalHadithsData.thematicCategories;
    final currentCategory = categories.firstWhere(
      (cat) => cat.id == _selectedThematicCategory,
      orElse: () => categories.first,
    );
    final list = _filterList(currentCategory.hadiths);

    return Column(
      children: [
        // Categories Horizontal Selector
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = cat.id == _selectedThematicCategory;

              return ChoiceChip(
                avatar: Text(cat.icon, style: const TextStyle(fontSize: 14)),
                label: Text(
                  cat.category,
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
                  setState(() => _selectedThematicCategory = cat.id);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: list.isEmpty
              ? _buildEmptyState("No Hadiths found in this category", isDark)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _buildHadithCard(list[index], isDark);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBookmarksTab(bool isDark) {
    final bookmarked = _allHadiths.where((h) => _bookmarkedIds.contains(h.number)).toList();
    final list = _filterList(bookmarked);

    if (_bookmarkedIds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.islamicGold.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border_rounded,
                  size: 48,
                  color: AppColors.islamicGold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "No Saved Hadiths Yet",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Tap the bookmark icon on any Hadith to save it for quick review and daily reflection.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Saved Hadith Collection",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.goldLight : AppColors.islamicGoldDark,
                ),
              ),
              Text(
                "${list.length} Saved",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _buildHadithCard(list[index], isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHadithCard(HadithItem hadith, bool isDark) {
    final isBookmarked = _bookmarkedIds.contains(hadith.number);
    final isSharhExpanded = _expandedSharh.contains(hadith.number);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Holographic3dCard(
        maxRotation: 0.08,
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
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Top Header: Number, Title, Grade badge & Actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hadith Number Badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGoldShiningGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "#${hadith.number}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title & Grade
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hadith.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.islamicGreen.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                hadith.grade,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.islamicGreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                hadith.topic,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.goldLight : AppColors.islamicGoldDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions: Bookmark & Share
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isBookmarked ? AppColors.islamicGold : (isDark ? Colors.white54 : Colors.black45),
                      size: 22,
                    ),
                    onPressed: () => _toggleBookmark(hadith.number),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: Icon(
                      Icons.copy_rounded,
                      color: isDark ? Colors.white54 : Colors.black45,
                      size: 19,
                    ),
                    onPressed: () => _copyHadith(hadith),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Arabic Matn (Body of Hadith)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.25) : const Color(0xFFFBF8F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.islamicGold.withOpacity(0.25),
                  ),
                ),
                child: Text(
                  hadith.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: _arabicFontSize,
                    fontWeight: FontWeight.bold,
                    height: 1.85,
                    color: isDark ? const Color(0xFFFEF3C7) : const Color(0xFF78350F),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // English Translation
              Text(
                "\"${hadith.translation}\"",
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  fontStyle: FontStyle.normal,
                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),

              // Narrator & Source citation footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.record_voice_over_rounded, size: 14, color: AppColors.astraSky),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hadith.narrator,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.astraSkyLight : AppColors.islamicPurpleDark,
                        ),
                      ),
                    ),
                    Text(
                      hadith.source,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Scholar Explanation (Sharh) Collapsible Section
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  setState(() {
                    if (isSharhExpanded) {
                      _expandedSharh.remove(hadith.number);
                    } else {
                      _expandedSharh.add(hadith.number);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Row(
                    children: [
                      Icon(
                        isSharhExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                        size: 18,
                        color: AppColors.islamicGold,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSharhExpanded ? "Hide Scholar Commentary (الشرح)" : "Read Scholar Commentary (الشرح)",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.islamicGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isSharhExpanded) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1B4B).withOpacity(0.6) : const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.islamicPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.school_rounded, size: 14, color: AppColors.islamicPurple),
                          const SizedBox(width: 6),
                          Text(
                            "Key Wisdom & Scholarly Guidance",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.astraSkyLight : AppColors.islamicPurpleDeep,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hadith.explanation,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: isDark ? AppColors.darkTextSecondary : const Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: isDark ? Colors.white30 : Colors.black26),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Arabic Text Size",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("A", style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Slider(
                          value: _arabicFontSize,
                          min: 16.0,
                          max: 32.0,
                          divisions: 8,
                          activeColor: AppColors.islamicGold,
                          onChanged: (val) {
                            setSheetState(() => _arabicFontSize = val);
                            setState(() => _arabicFontSize = val);
                          },
                        ),
                      ),
                      const Text("A", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : const Color(0xFFFBF8F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: _arabicFontSize,
                        color: AppColors.islamicGold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
