import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/models/quran_models.dart';
import '../../data/services/quran_service.dart';
import '../../data/services/audio_service.dart';
import '../../data/sources/mushaf_page_data.dart';
import '../../data/sources/quran_surahs_data.dart';
import 'widgets/quran_mushaf_view.dart';

enum QuranViewMode { mushaf, translation }

class SurahReaderScreen extends StatefulWidget {
  final Surah surah;

  const SurahReaderScreen({super.key, required this.surah});

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  late int _currentSurahNumber;
  Surah get _currentSurah => QuranSurahsData.getByNumber(_currentSurahNumber);
  late PageController _surahPageController;
  QuranViewMode _viewMode = QuranViewMode.mushaf; // Defaults to authentic Real Quran Mushaf!
  MushafThemeMode _themeMode = MushafThemeMode.madani;
  double _fontSize = 24.0;
  bool _showTranslation = true;
  bool _showTransliteration = true;
  Ayah? _currentlyPlayingAyah;

  @override
  void initState() {
    super.initState();
    _currentSurahNumber = widget.surah.number;
    _surahPageController = PageController(initialPage: _currentSurahNumber - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<QuranService>().prefetchAdjacentSurahs(_currentSurahNumber);
      }
    });
  }

  @override
  void dispose() {
    _surahPageController.dispose();
    super.dispose();
  }

  void _onSurahChanged(int newSurahNumber) {
    if (newSurahNumber < 1 || newSurahNumber > 114) return;
    if (_currentSurahNumber == newSurahNumber) return;
    setState(() {
      _currentSurahNumber = newSurahNumber;
      _currentlyPlayingAyah = null;
    });
    if (_surahPageController.hasClients && _surahPageController.page?.round() != newSurahNumber - 1) {
      _surahPageController.jumpToPage(newSurahNumber - 1);
    }
    context.read<QuranService>().prefetchAdjacentSurahs(newSurahNumber);
  }

  void _goToNextSurah() {
    if (_currentSurahNumber < 114) {
      if (_viewMode == QuranViewMode.translation && _surahPageController.hasClients) {
        _surahPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _onSurahChanged(_currentSurahNumber + 1);
      }
    }
  }

  void _goToPrevSurah() {
    if (_currentSurahNumber > 1) {
      if (_viewMode == QuranViewMode.translation && _surahPageController.hasClients) {
        _surahPageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _onSurahChanged(_currentSurahNumber - 1);
      }
    }
  }

  void _playSurahAudio() {
    final audioService = context.read<AudioService>();
    final url = "https://server8.mp3quran.net/afs/${_currentSurahNumber.toString().padLeft(3, '0')}.mp3";
    setState(() => _currentlyPlayingAyah = null);
    audioService.playStream(
      url,
      title: "Surah ${_currentSurah.englishName}",
      subtitle: "Mishary Rashid Alafasy",
    );
  }

  void _playSpecificAyah(Ayah ayah) {
    final audioService = context.read<AudioService>();
    setState(() => _currentlyPlayingAyah = ayah);
    // Verse recitation audio URL
    final url = "https://cdn.islamic.network/quran/audio/128/ar.alafasy/${ayah.number}.mp3";
    audioService.playStream(
      url,
      title: "Surah ${_currentSurah.englishName} [Ayah ${ayah.numberInSurah}]",
      subtitle: "Mishary Rashid Alafasy",
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text(
                    "Quran Display Settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),

                  // Font Size Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Arabic Font Size", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text("${_fontSize.round()} pt", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.goldWarm)),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 18.0,
                    max: 36.0,
                    divisions: 9,
                    activeColor: AppColors.goldWarm,
                    onChanged: (val) {
                      setModalState(() => _fontSize = val);
                      setState(() => _fontSize = val);
                    },
                  ),

                  const SizedBox(height: 14),

                  // Mushaf Paper Theme
                  const Text("Mushaf Paper Style", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildThemeOption("Madani", AppColors.mushafMadaniBg, MushafThemeMode.madani, setModalState),
                      _buildThemeOption("Antique", AppColors.mushafAntiqueBg, MushafThemeMode.antique, setModalState),
                      _buildThemeOption("Midnight", AppColors.mushafDarkBg, MushafThemeMode.midnight, setModalState),
                      _buildThemeOption("Emerald", AppColors.mushafEmeraldBg, MushafThemeMode.emerald, setModalState),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeOption(String label, Color bg, MushafThemeMode mode, StateSetter setModalState) {
    final isSelected = _themeMode == mode;
    return GestureDetector(
      onTap: () {
        setModalState(() => _themeMode = mode);
        setState(() => _themeMode = mode);
      },
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.goldWarm : Colors.grey.withOpacity(0.4),
                width: isSelected ? 2.5 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: AppColors.goldWarm.withOpacity(0.3), blurRadius: 8)]
                  : null,
            ),
            alignment: Alignment.center,
            child: isSelected ? const Icon(Icons.check_rounded, color: AppColors.goldWarm, size: 20) : null,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final audioService = context.watch<AudioService>();
    final currentSurah = _currentSurah;
    final isPlayingThis = audioService.isPlaying && audioService.currentTitle?.contains(currentSurah.englishName) == true;

    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: AnimatedBackButton(
            size: 38,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Previous Surah Chevron Button
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 24),
              color: _currentSurahNumber > 1 ? AppColors.islamicGold : Colors.grey.withOpacity(0.3),
              tooltip: _currentSurahNumber > 1 ? "Previous Surah" : null,
              onPressed: _currentSurahNumber > 1 ? _goToPrevSurah : null,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          currentSurah.englishName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        currentSurah.name,
                        style: GoogleFonts.amiri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.islamicGold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${currentSurah.revelationType} • ${currentSurah.numberOfAyahs} Verses • $_currentSurahNumber/114",
                    style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white60 : Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Next Surah Chevron Button
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, size: 24),
              color: _currentSurahNumber < 114 ? AppColors.islamicGold : Colors.grey.withOpacity(0.3),
              tooltip: _currentSurahNumber < 114 ? "Next Surah" : null,
              onPressed: _currentSurahNumber < 114 ? _goToNextSurah : null,
            ),
          ],
        ),
        actions: [
          // Audio Recitation
          IconButton(
            icon: Icon(
              isPlayingThis ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: AppColors.islamicGold,
              size: 28,
            ),
            tooltip: "Listen Recitation",
            onPressed: _playSurahAudio,
          ),
          // Display Settings (Font size & paper theme)
          IconButton(
            icon: const Icon(Icons.tune_rounded, size: 22),
            tooltip: "Display Settings",
            onPressed: () => _showSettingsModal(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Mushaf Mode
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _viewMode = QuranViewMode.mushaf),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _viewMode == QuranViewMode.mushaf
                            ? (isDark ? AppColors.islamicPurple : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _viewMode == QuranViewMode.mushaf
                            ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 16,
                            color: _viewMode == QuranViewMode.mushaf
                                ? AppColors.islamicGold
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Mushaf (Real Quran)",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _viewMode == QuranViewMode.mushaf
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Translation & Tafsir Mode
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _viewMode = QuranViewMode.translation),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _viewMode == QuranViewMode.translation
                            ? (isDark ? AppColors.islamicPurple : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _viewMode == QuranViewMode.translation
                            ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_rounded,
                            size: 16,
                            color: _viewMode == QuranViewMode.translation
                                ? AppColors.islamicGold
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Verses & Translation",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _viewMode == QuranViewMode.translation
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _viewMode == QuranViewMode.mushaf
          ? QuranMushafView(
              surah: currentSurah,
              ayahs: const [],
              initialPage: MushafPageData.surahStartPages[_currentSurahNumber] ?? 1,
              themeMode: _themeMode,
              onPlayAyah: _playSpecificAyah,
              onSurahChanged: (surahNum) {
                if (mounted && _currentSurahNumber != surahNum) {
                  setState(() {
                    _currentSurahNumber = surahNum;
                  });
                  if (_surahPageController.hasClients &&
                      _surahPageController.page?.round() != surahNum - 1) {
                    _surahPageController.jumpToPage(surahNum - 1);
                  }
                  context.read<QuranService>().prefetchAdjacentSurahs(surahNum);
                }
              },
            )
          : Stack(
              children: [
                // Horizontal Swipe PageView between Surahs
                PageView.builder(
                  controller: _surahPageController,
                  itemCount: 114,
                  onPageChanged: (index) {
                    final surahNum = index + 1;
                    setState(() {
                      _currentSurahNumber = surahNum;
                      _currentlyPlayingAyah = null;
                    });
                    context.read<QuranService>().prefetchAdjacentSurahs(surahNum);
                  },
                  itemBuilder: (context, index) {
                    final surahNum = index + 1;
                    return _SingleSurahVersesView(
                      key: ValueKey("surah_$surahNum"),
                      surahNumber: surahNum,
                      fontSize: _fontSize,
                      showTranslation: _showTranslation,
                      showTransliteration: _showTransliteration,
                      currentlyPlayingAyah: _currentlyPlayingAyah,
                      onPlayAyah: _playSpecificAyah,
                      onGoToNextSurah: _goToNextSurah,
                      onGoToPrevSurah: _goToPrevSurah,
                    );
                  },
                ),

                // Floating Surah Quick Navigation Bar (Swipe ↔ or Tap)
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity != null) {
                        if (details.primaryVelocity! < -150) {
                          _goToNextSurah();
                        } else if (details.primaryVelocity! > 150) {
                          _goToPrevSurah();
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardBg.withOpacity(0.95) : Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.islamicPurple.withOpacity(0.4), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: _currentSurahNumber > 1 ? _goToPrevSurah : null,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    size: 20,
                                    color: _currentSurahNumber > 1 ? AppColors.islamicGold : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _currentSurahNumber > 1
                                        ? QuranSurahsData.getByNumber(_currentSurahNumber - 1).englishName
                                        : "Start",
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: _currentSurahNumber > 1 ? AppColors.islamicGold : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.islamicPurple.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.swap_horiz_rounded, size: 14, color: AppColors.islamicPurple),
                                const SizedBox(width: 4),
                                Text(
                                  "Surah $_currentSurahNumber / 114 (Swipe ↔)",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.islamicPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: _currentSurahNumber < 114 ? _goToNextSurah : null,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _currentSurahNumber < 114
                                        ? QuranSurahsData.getByNumber(_currentSurahNumber + 1).englishName
                                        : "End",
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: _currentSurahNumber < 114 ? AppColors.islamicGold : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 20,
                                    color: _currentSurahNumber < 114 ? AppColors.islamicGold : Colors.grey,
                                  ),
                                ],
                              ),
                            ),
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

class _SingleSurahVersesView extends StatefulWidget {
  final int surahNumber;
  final double fontSize;
  final bool showTranslation;
  final bool showTransliteration;
  final Ayah? currentlyPlayingAyah;
  final Function(Ayah) onPlayAyah;
  final VoidCallback? onGoToNextSurah;
  final VoidCallback? onGoToPrevSurah;

  const _SingleSurahVersesView({
    super.key,
    required this.surahNumber,
    required this.fontSize,
    required this.showTranslation,
    required this.showTransliteration,
    required this.currentlyPlayingAyah,
    required this.onPlayAyah,
    this.onGoToNextSurah,
    this.onGoToPrevSurah,
  });

  @override
  State<_SingleSurahVersesView> createState() => _SingleSurahVersesViewState();
}

class _SingleSurahVersesViewState extends State<_SingleSurahVersesView> {
  List<Ayah>? _ayahs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    final quranService = context.read<QuranService>();
    final ayahs = await quranService.fetchSurahAyahs(widget.surahNumber);
    if (mounted) {
      setState(() {
        _ayahs = ayahs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surah = QuranSurahsData.getByNumber(widget.surahNumber);

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.islamicGold),
      );
    }

    final ayahs = _ayahs ?? [];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: ayahs.length + 2, // +1 for Bismillah banner, +1 for Next Surah footer card
      itemBuilder: (context, index) {
        // 1. Header Banner
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF241544), Color(0xFF15102A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFFFAF5FF), Color(0xFFF3E8FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.islamicGold.withOpacity(0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.islamicGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${surah.revelationType} • ${surah.numberOfAyahs} Verses",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                      ),
                    ),
                    Text(
                      surah.englishNameTranslation,
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Bismillah Calligraphy (excluded for Surah At-Tawba #9)
                if (widget.surahNumber != 9) ...[
                  Text(
                    "بِسْمِ اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiriQuran(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.islamicGold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "In the name of Allah, the Entirely Merciful, the Especially Merciful",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        // 3. Footer Next/Prev Surah Card
        if (index == ayahs.length + 1) {
          final hasNext = widget.surahNumber < 114;
          final nextSurah = hasNext ? QuranSurahsData.getByNumber(widget.surahNumber + 1) : null;
          final hasPrev = widget.surahNumber > 1;
          final prevSurah = hasPrev ? QuranSurahsData.getByNumber(widget.surahNumber - 1) : null;

          return Container(
            margin: const EdgeInsets.only(top: 8, bottom: 20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.islamicPurple.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.islamicGold, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "End of Surah ${surah.englishName}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Swipe left ↔ or tap below to continue to the next Surah",
                  style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white60 : Colors.grey[600]),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (hasPrev)
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.islamicGold,
                            side: const BorderSide(color: AppColors.islamicGold),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.arrow_back_rounded, size: 16),
                          label: Text(
                            prevSurah!.englishName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: widget.onGoToPrevSurah,
                        ),
                      ),
                    if (hasPrev && hasNext) const SizedBox(width: 10),
                    if (hasNext)
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.islamicPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          label: Text(
                            nextSurah!.englishName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          onPressed: widget.onGoToNextSurah,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }

        // 2. Ayah Item
        final ayah = ayahs[index - 1];
        final isPlaying = widget.currentlyPlayingAyah?.number == ayah.number;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPlaying
                ? (isDark ? AppColors.islamicPurple.withOpacity(0.25) : const Color(0xFFF5F3FF))
                : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPlaying
                  ? AppColors.islamicPurple
                  : (isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF)),
              width: isPlaying ? 1.5 : 1,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top row: Verse number + Quick Play + Bookmark
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.islamicGold.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.islamicGold.withOpacity(0.4)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${ayah.numberInSurah}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_outline_rounded,
                          size: 22,
                          color: AppColors.islamicGold,
                        ),
                        onPressed: () => widget.onPlayAyah(ayah),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border_rounded, size: 20, color: Colors.grey),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Bookmarked Ayah ${ayah.numberInSurah} (${surah.englishName})"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Arabic Verse
              Text(
                ayah.text,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiriQuran(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.normal,
                  height: 2.2,
                ),
              ),

              // Transliteration
              if (widget.showTransliteration && ayah.transliteration.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  ayah.transliteration,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: isDark ? const Color(0xFFC4B5FD) : const Color(0xFF7C3AED),
                  ),
                ),
              ],

              // English Translation
              if (widget.showTranslation && ayah.translation.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  ayah.translation,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
