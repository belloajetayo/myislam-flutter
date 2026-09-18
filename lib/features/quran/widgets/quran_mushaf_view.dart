import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/islamic_ornaments.dart';
import '../../../data/models/quran_models.dart';
import '../../../data/sources/mushaf_page_data.dart';

enum MushafThemeMode { madani, antique, midnight, emerald }

/// Authentic Hard Copy Quran Mushaf View (15-line King Fahd Glorious Quran Printing Complex standard)
class QuranMushafView extends StatefulWidget {
  final Surah surah;
  final List<Ayah> ayahs;
  final int initialPage;
  final MushafThemeMode themeMode;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onSurahChanged;
  final Function(Ayah ayah)? onPlayAyah;

  const QuranMushafView({
    super.key,
    required this.surah,
    required this.ayahs,
    this.initialPage = 1,
    this.themeMode = MushafThemeMode.madani,
    this.onPageChanged,
    this.onSurahChanged,
    this.onPlayAyah,
  });

  @override
  State<QuranMushafView> createState() => _QuranMushafViewState();
}

class _QuranMushafViewState extends State<QuranMushafView> {
  late PageController _pageController;
  late int _currentPage;
  bool _showControls = true;
  final TransformationController _transformController = TransformationController();

  @override
  void initState() {
    super.initState();
    // Resolve initial page: from widget prop, or from first Ayah, or from Surah metadata
    int startPage = widget.initialPage;
    if (widget.ayahs.isNotEmpty && widget.ayahs.first.page > 0) {
      startPage = widget.ayahs.first.page;
    } else {
      startPage = MushafPageData.surahStartPages[widget.surah.number] ?? widget.initialPage;
    }
    _currentPage = startPage.clamp(1, MushafPageData.totalPages);
    _pageController = PageController(initialPage: _currentPage - 1);
  }

  @override
  void didUpdateWidget(covariant QuranMushafView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surah.number != widget.surah.number) {
      int targetPage = widget.initialPage;
      if (widget.ayahs.isNotEmpty && widget.ayahs.first.page > 0) {
        targetPage = widget.ayahs.first.page;
      } else {
        targetPage = MushafPageData.surahStartPages[widget.surah.number] ?? 1;
      }
      _jumpToPage(targetPage);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _jumpToPage(int page) {
    final clamped = page.clamp(1, MushafPageData.totalPages);
    setState(() => _currentPage = clamped);
    _pageController.jumpToPage(clamped - 1);
    widget.onPageChanged?.call(clamped);
    _transformController.value = Matrix4.identity();
  }

  void _nextPage() {
    if (_currentPage < MushafPageData.totalPages) {
      _jumpToPage(_currentPage + 1);
    }
  }

  void _prevPage() {
    if (_currentPage > 1) {
      _jumpToPage(_currentPage - 1);
    }
  }

  void _nextSurah() {
    final currentSurahNum = MushafPageData.getPrimarySurahNumberForPage(_currentPage);
    if (currentSurahNum < 114) {
      final targetSurah = currentSurahNum + 1;
      final targetPage = MushafPageData.surahStartPages[targetSurah] ?? _currentPage;
      _jumpToPage(targetPage);
      widget.onSurahChanged?.call(targetSurah);
    }
  }

  void _prevSurah() {
    final currentSurahNum = MushafPageData.getPrimarySurahNumberForPage(_currentPage);
    if (currentSurahNum > 1) {
      final targetSurah = currentSurahNum - 1;
      final targetPage = MushafPageData.surahStartPages[targetSurah] ?? 1;
      _jumpToPage(targetPage);
      widget.onSurahChanged?.call(targetSurah);
    }
  }

  Color get _pageBgColor {
    switch (widget.themeMode) {
      case MushafThemeMode.madani:
        return const Color(0xFFFBF7EE); // Authentic King Fahd printed paper
      case MushafThemeMode.antique:
        return const Color(0xFFF5EFE0); // Warm aged vellum
      case MushafThemeMode.midnight:
        return const Color(0xFF0F172A); // Deep dark
      case MushafThemeMode.emerald:
        return const Color(0xFF052319); // Rich emerald
    }
  }

  Color get _mushafBorderColor {
    switch (widget.themeMode) {
      case MushafThemeMode.madani:
        return const Color(0xFFC5A869);
      case MushafThemeMode.antique:
        return const Color(0xFF9E8148);
      case MushafThemeMode.midnight:
        return const Color(0xFFB4975A);
      case MushafThemeMode.emerald:
        return const Color(0xFFD4AF37);
    }
  }

  bool get _isDark =>
      widget.themeMode == MushafThemeMode.midnight ||
      widget.themeMode == MushafThemeMode.emerald;

  void _showQuickJumpModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DefaultTabController(
          length: 3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.72,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(
              color: _isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Navigate Holy Quran",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),

                // Tabs: Surah, Juz, Page
                const TabBar(
                  labelColor: AppColors.islamicGold,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.islamicGold,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(text: "Surah (1-114)"),
                    Tab(text: "Juz (1-30)"),
                    Tab(text: "Direct Page"),
                  ],
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: TabBarView(
                    children: [
                      // 1. Surahs list
                      ListView.builder(
                        itemCount: 114,
                        itemBuilder: (context, i) {
                          final surahNum = i + 1;
                          final page = MushafPageData.surahStartPages[surahNum] ?? 1;
                          final nameEn = MushafPageData.surahNames[surahNum] ?? "";
                          final nameAr = MushafPageData.surahNamesArabic[surahNum] ?? "";
                          final isCurrent = page == _currentPage;

                          return ListTile(
                            dense: true,
                            leading: Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? AppColors.goldWarm
                                    : (_isDark ? Colors.white12 : const Color(0xFFF1F5F9)),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$surahNum",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent
                                      ? Colors.white
                                      : (_isDark ? Colors.white70 : Colors.black87),
                                ),
                              ),
                            ),
                            title: Text(nameEn, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            subtitle: Text("Page $page", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            trailing: Text(
                              nameAr,
                              style: GoogleFonts.amiri(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.islamicGold,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              _jumpToPage(page);
                            },
                          );
                        },
                      ),

                      // 2. Juz list
                      ListView.builder(
                        itemCount: 30,
                        itemBuilder: (context, i) {
                          final juzNum = i + 1;
                          final page = MushafPageData.juzStartPages[i];
                          final titleAr = MushafPageData.juzTitlesArabic[i];
                          final isCurrent = MushafPageData.getJuzForPage(_currentPage) == juzNum;

                          return ListTile(
                            dense: true,
                            leading: Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? AppColors.emeraldPrimary
                                    : (_isDark ? Colors.white12 : const Color(0xFFECFDF5)),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$juzNum",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? Colors.white : AppColors.emeraldPrimary,
                                ),
                              ),
                            ),
                            title: Text("Juz $juzNum", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text("Starts on Page $page", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            trailing: Text(
                              titleAr,
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.amiri(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldWarm,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              _jumpToPage(page);
                            },
                          );
                        },
                      ),

                      // 3. Direct Page input & quick grid
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Current Page: $_currentPage of 604",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Slider(
                            value: _currentPage.toDouble(),
                            min: 1,
                            max: 604,
                            divisions: 603,
                            activeColor: AppColors.goldWarm,
                            label: "Page $_currentPage",
                            onChanged: (val) {
                              _jumpToPage(val.round());
                            },
                          ),
                          const Divider(),
                          const Text(
                            "Jump by 50 Pages",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [1, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 604].map((p) {
                              return ActionChip(
                                label: Text("P. $p"),
                                backgroundColor: _currentPage == p
                                    ? AppColors.goldWarm.withOpacity(0.2)
                                    : null,
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _jumpToPage(p);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentJuz = MushafPageData.getJuzForPage(_currentPage);
    final juzArabic = "الجُزْءُ ${toArabicDigits(currentJuz)}";
    final surahNum = MushafPageData.getPrimarySurahNumberForPage(_currentPage);
    final surahArabic = "سُورَةُ ${MushafPageData.surahNamesArabic[surahNum] ?? widget.surah.name}";
    final surahEnglish = MushafPageData.surahNames[surahNum] ?? widget.surah.englishName;

    return Container(
      color: _pageBgColor,
      child: Stack(
        children: [
          // Main Page View (Horizontal swipe between 604 pages)
          GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            child: PageView.builder(
              controller: _pageController,
              itemCount: MushafPageData.totalPages,
              onPageChanged: (index) {
                final page = index + 1;
                setState(() => _currentPage = page);
                widget.onPageChanged?.call(page);
                _transformController.value = Matrix4.identity();
                final surahNum = MushafPageData.getPrimarySurahNumberForPage(page);
                widget.onSurahChanged?.call(surahNum);
              },
              itemBuilder: (context, index) {
                final pageNumber = index + 1;
                final isOddPage = pageNumber % 2 != 0; // Odd = right page, Even = left page
                final pageUrl = MushafPageData.getPageImageUrl(pageNumber);

                return InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 1.0,
                  maxScale: 3.5,
                  clipBehavior: Clip.none,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: _pageBgColor,
                        // Realistic Quran book binding: spine shadow on right for even pages, left for odd pages
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: isOddPage ? const Offset(-4, 0) : const Offset(4, 0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Inverted color filter for night mode if selected
                          ColorFiltered(
                            colorFilter: widget.themeMode == MushafThemeMode.midnight
                                ? const ColorFilter.matrix([
                                    -1.0, 0, 0, 0, 255, // red
                                    0, -1.0, 0, 0, 255, // green
                                    0, 0, -1.0, 0, 255, // blue
                                    0, 0, 0, 1.0, 0,    // alpha
                                  ])
                                : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                            child: Image.network(
                              pageUrl,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 38,
                                        height: 38,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                          color: AppColors.goldWarm,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        "Opening Page ${toArabicDigits(pageNumber)} (Madani Mushaf)...",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: _mushafBorderColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.wifi_off_rounded, size: 36, color: Colors.orange),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Page $pageNumber",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "Could not load authentic page plate. Please check your internet connection.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 12),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.goldWarm,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          icon: const Icon(Icons.refresh_rounded, size: 16),
                                          label: const Text("Retry Page"),
                                          onPressed: () {
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Subtle Physical Book Spine Gradient Overlay
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: isOddPage ? 0 : null,
                            right: isOddPage ? null : 0,
                            width: 18,
                            child: IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: isOddPage ? Alignment.centerLeft : Alignment.centerRight,
                                    end: isOddPage ? Alignment.centerRight : Alignment.centerLeft,
                                    colors: [
                                      Colors.black.withOpacity(0.07),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top Header Bar (Surah Name, Juz Title, Navigation Trigger)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            top: _showControls ? 0 : -80,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (_isDark ? Colors.black : Colors.white).withOpacity(0.92),
                    (_isDark ? Colors.black : Colors.white).withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Juz Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.goldWarm.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.goldWarm.withOpacity(0.35)),
                      ),
                      child: Text(
                        "$juzArabic • Juz $currentJuz",
                        style: GoogleFonts.amiri(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldRoyal,
                        ),
                      ),
                    ),

                    // Quick Jump Trigger
                    GestureDetector(
                      onTap: _showQuickJumpModal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.emeraldPrimary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.emeraldPrimary.withOpacity(0.35)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.emeraldPrimary),
                            const SizedBox(width: 6),
                            Text(
                              "P. $_currentPage",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.emeraldPrimary,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down_rounded, size: 18, color: AppColors.emeraldPrimary),
                          ],
                        ),
                      ),
                    ),

                    // Surah Name Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.goldWarm.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.goldWarm.withOpacity(0.35)),
                      ),
                      child: Text(
                        "$surahArabic ($surahEnglish)",
                        style: GoogleFonts.amiri(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldRoyal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar (Page Number, Navigation Arrows, Fast Scrub Slider)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            bottom: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    (_isDark ? Colors.black : Colors.white).withOpacity(0.95),
                    (_isDark ? Colors.black : Colors.white).withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Surah Navigation Bar (Swipe ↔ or Tap to move to another Surah)
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity != null) {
                          if (details.primaryVelocity! < -150) {
                            _nextSurah();
                          } else if (details.primaryVelocity! > 150) {
                            _prevSurah();
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _isDark ? AppColors.darkCardBg.withOpacity(0.95) : const Color(0xFFFDFBF7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.islamicPurple.withOpacity(0.4), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(_isDark ? 0.3 : 0.05),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: surahNum > 1 ? _prevSurah : null,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.arrow_back_ios_rounded, size: 12, color: surahNum > 1 ? AppColors.islamicGold : Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      surahNum > 1 ? (MushafPageData.surahNames[surahNum - 1] ?? "Prev") : "Start",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: surahNum > 1 ? AppColors.islamicGold : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.islamicPurple.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.swap_horiz_rounded, size: 14, color: AppColors.islamicPurple),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Surah $surahNum / 114 (Swipe ↔)",
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.islamicPurple),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: surahNum < 114 ? _nextSurah : null,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      surahNum < 114 ? (MushafPageData.surahNames[surahNum + 1] ?? "Next") : "End",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: surahNum < 114 ? AppColors.islamicGold : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: surahNum < 114 ? AppColors.islamicGold : Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Slider
                    SizedBox(
                      height: 28,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: AppColors.goldWarm,
                          inactiveTrackColor: Colors.grey.withOpacity(0.3),
                          thumbColor: AppColors.goldWarm,
                        ),
                        child: Slider(
                          value: _currentPage.toDouble(),
                          min: 1,
                          max: 604,
                          divisions: 603,
                          onChanged: (val) {
                            _jumpToPage(val.round());
                          },
                        ),
                      ),
                    ),

                    // Controls Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Next Page (Islamic Quran advances to right-to-left, so next page is on the left)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isDark ? Colors.white12 : const Color(0xFFF1F5F9),
                            foregroundColor: _isDark ? Colors.white : Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.arrow_back_ios_rounded, size: 13),
                          label: const Text("Next P.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          onPressed: _currentPage < MushafPageData.totalPages ? _nextPage : null,
                        ),

                        // Page indicator button
                        GestureDetector(
                          onTap: _showQuickJumpModal,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.goldWarm.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.goldWarm.withOpacity(0.4)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "صفحة ${toArabicDigits(_currentPage)}",
                                  style: GoogleFonts.amiri(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.goldRoyal,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "($_currentPage / 604)",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.goldWarm,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Previous Page
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isDark ? Colors.white12 : const Color(0xFFF1F5F9),
                            foregroundColor: _isDark ? Colors.white : Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          label: const Text("Prev P.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 13),
                          onPressed: _currentPage > 1 ? _prevPage : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
