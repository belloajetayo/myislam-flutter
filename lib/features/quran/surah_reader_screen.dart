import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/quran_models.dart';
import '../../data/services/quran_service.dart';
import '../../data/services/audio_service.dart';

class SurahReaderScreen extends StatefulWidget {
  final Surah surah;

  const SurahReaderScreen({super.key, required this.surah});

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  List<Ayah> _ayahs = [];
  bool _isLoading = true;
  bool _showTranslation = true;
  bool _showTransliteration = true;

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
    // High quality recitation from Sheikh Mishary Alafasy
    final url = "https://server8.mp3quran.net/afs/${widget.surah.number.toString().padLeft(3, '0')}.mp3";
    audioService.playStream(
      url,
      title: "Surah ${widget.surah.englishName}",
      subtitle: "Mishary Rashid Alafasy",
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
          IconButton(
            icon: Icon(
              isPlayingThis ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: AppColors.islamicGold,
              size: 28,
            ),
            onPressed: _playSurahAudio,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) {
              setState(() {
                if (val == "trans") _showTranslation = !_showTranslation;
                if (val == "phon") _showTransliteration = !_showTransliteration;
              });
            },
            itemBuilder: (_) => [
              CheckedPopupMenuItem(
                value: "trans",
                checked: _showTranslation,
                child: const Text("Show Translation"),
              ),
              CheckedPopupMenuItem(
                value: "phon",
                checked: _showTransliteration,
                child: const Text("Show Transliteration"),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.islamicGold))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                // Bismillah Banner (except Surah At-Tawbah 9)
                if (widget.surah.number != 9)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? const LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)])
                          : AppColors.heroPrayerGradient,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.islamicGold.withOpacity(0.3)),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // Ayahs List
                ..._ayahs.map((ayah) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Verse number badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.islamicGold.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${ayah.numberInSurah}",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark_border_rounded, size: 20, color: Colors.grey),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Bookmarked Ayah ${ayah.numberInSurah}")),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Arabic Verse Text
                        Text(
                          ayah.text,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            height: 2.0,
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
                }),
              ],
            ),
    );
  }
}
