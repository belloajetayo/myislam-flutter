import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/quran_models.dart';
import '../../data/services/quran_service.dart';
import '../../data/services/audio_service.dart';
import 'widgets/quran_mushaf_view.dart';

enum QuranViewMode { mushaf, translation }

class SurahReaderScreen extends StatefulWidget {
  final Surah surah;

  const SurahReaderScreen({super.key, required this.surah});

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  List<Ayah> _ayahs = [];
  bool _isLoading = true;
  QuranViewMode _viewMode = QuranViewMode.mushaf; // Defaults to authentic Real Quran Mushaf!
  MushafThemeMode _themeMode = MushafThemeMode.madani;
  double _fontSize = 24.0;
  bool _showTranslation = true;
  bool _showTransliteration = true;
  Ayah? _currentlyPlayingAyah;

  @override
  void initState() {
    super.initState();
    _loadAyahs();
  }

  Future<void> _loadAyahs() async {
    final quranService = context.read<QuranService>();
    final ayahs = await quranService.fetchSurahAyahs(widget.surah.number);
    if (mounted) {
      setState(() {
        _ayahs = ayahs;
        _isLoading = false;
      });
    }
  }

  void _playSurahAudio() {
    final audioService = context.read<AudioService>();
    final url = "https://server8.mp3quran.net/afs/${widget.surah.number.toString().padLeft(3, '0')}.mp3";
    setState(() => _currentlyPlayingAyah = null);
    audioService.playStream(
      url,
      title: "Surah ${widget.surah.englishName}",
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
      title: "Surah ${widget.surah.englishName} [Ayah ${ayah.numberInSurah}]",
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
    final isPlayingThis = audioService.isPlaying && audioService.currentTitle?.contains(widget.surah.englishName) == true;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.surah.englishName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              "${widget.surah.revelationType} • ${widget.surah.numberOfAyahs} Verses",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          // Audio Recitation
          IconButton(
            icon: Icon(
              isPlayingThis ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: AppColors.goldWarm,
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
                            ? (isDark ? AppColors.emeraldForest : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _viewMode == QuranViewMode.mushaf
                            ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)]
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
                                ? AppColors.goldWarm
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Mushaf (Real Quran)",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _viewMode == QuranViewMode.mushaf
                                  ? (_isDarkTheme() ? Colors.white : AppColors.lightTextPrimary)
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
                            ? (isDark ? AppColors.emeraldForest : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _viewMode == QuranViewMode.translation
                            ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)]
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
                                ? AppColors.goldWarm
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Verses & Translation",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _viewMode == QuranViewMode.translation
                                  ? (_isDarkTheme() ? Colors.white : AppColors.lightTextPrimary)
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.goldWarm))
          : _viewMode == QuranViewMode.mushaf
              ? QuranMushafView(
                  surah: widget.surah,
                  ayahs: _ayahs,
                  fontSize: _fontSize,
                  themeMode: _themeMode,
                  currentlyPlayingAyah: _currentlyPlayingAyah,
                  onPlayAyah: _playSpecificAyah,
                )
              : _buildTranslationListView(isDark),
    );
  }

  bool _isDarkTheme() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildTranslationListView(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 60),
      itemCount: _ayahs.length,
      itemBuilder: (context, index) {
        final ayah = _ayahs[index];
        final isPlaying = _currentlyPlayingAyah?.number == ayah.number;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isPlaying
                ? (isDark ? AppColors.emeraldForest.withOpacity(0.25) : const Color(0xFFECFDF5))
                : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPlaying
                  ? AppColors.emeraldPrimary
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
                      color: AppColors.goldWarm.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${ayah.numberInSurah}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.goldWarm),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_outline_rounded,
                          size: 22,
                          color: AppColors.emeraldPrimary,
                        ),
                        onPressed: () => _playSpecificAyah(ayah),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border_rounded, size: 20, color: Colors.grey),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Bookmarked Ayah ${ayah.numberInSurah}"),
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
                  fontSize: _fontSize,
                  fontWeight: FontWeight.normal,
                  height: 2.2,
                ),
              ),

              // Transliteration
              if (_showTransliteration && ayah.transliteration.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  ayah.transliteration,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                  ),
                ),
              ],

              // English Translation
              if (_showTranslation && ayah.translation.isNotEmpty) ...[
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
