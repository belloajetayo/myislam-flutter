import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/islamic_ornaments.dart';
import '../../../data/models/quran_models.dart';

enum MushafThemeMode { madani, antique, midnight, emerald }

class QuranMushafView extends StatefulWidget {
  final Surah surah;
  final List<Ayah> ayahs;
  final double fontSize;
  final MushafThemeMode themeMode;
  final Ayah? currentlyPlayingAyah;
  final Function(Ayah ayah)? onPlayAyah;

  const QuranMushafView({
    super.key,
    required this.surah,
    required this.ayahs,
    this.fontSize = 24.0,
    this.themeMode = MushafThemeMode.madani,
    this.currentlyPlayingAyah,
    this.onPlayAyah,
  });

  @override
  State<QuranMushafView> createState() => _QuranMushafViewState();
}

class _QuranMushafViewState extends State<QuranMushafView> {
  Ayah? _selectedAyah;

  // Theme color resolvers
  Color get _bgColor {
    switch (widget.themeMode) {
      case MushafThemeMode.madani:
        return AppColors.mushafMadaniBg;
      case MushafThemeMode.antique:
        return AppColors.mushafAntiqueBg;
      case MushafThemeMode.midnight:
        return AppColors.mushafDarkBg;
      case MushafThemeMode.emerald:
        return AppColors.mushafEmeraldBg;
    }
  }

  Color get _borderColor {
    switch (widget.themeMode) {
      case MushafThemeMode.madani:
        return AppColors.mushafMadaniBorder;
      case MushafThemeMode.antique:
        return AppColors.mushafAntiqueBorder;
      case MushafThemeMode.midnight:
        return AppColors.mushafDarkBorder;
      case MushafThemeMode.emerald:
        return AppColors.mushafEmeraldBorder;
    }
  }

  Color get _textColor {
    switch (widget.themeMode) {
      case MushafThemeMode.madani:
        return AppColors.mushafMadaniText;
      case MushafThemeMode.antique:
        return AppColors.mushafAntiqueText;
      case MushafThemeMode.midnight:
        return AppColors.mushafDarkText;
      case MushafThemeMode.emerald:
        return AppColors.mushafEmeraldText;
    }
  }

  bool get _isDark => widget.themeMode == MushafThemeMode.midnight || widget.themeMode == MushafThemeMode.emerald;

  void _showAyahDetailsSheet(BuildContext context, Ayah ayah) {
    setState(() => _selectedAyah = ayah);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: _isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: _borderColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Top Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.goldWarm.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.goldWarm.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.goldWarm),
                        const SizedBox(width: 6),
                        Text(
                          "Surah ${widget.surah.englishName} • Ayah ${ayah.numberInSurah}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldWarm,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Arabic Verse
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _bgColor.withOpacity(_isDark ? 0.2 : 0.6),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _borderColor.withOpacity(0.2)),
                ),
                child: Text(
                  ayah.text,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiriQuran(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _isDark ? Colors.white : const Color(0xFF1E1915),
                    height: 2.1,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Transliteration
              if (ayah.transliteration.isNotEmpty) ...[
                Text(
                  ayah.transliteration,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: _isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // English Translation
              if (ayah.translation.isNotEmpty) ...[
                Text(
                  ayah.translation,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: _isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Action Buttons Row
              Row(
                children: [
                  // Play Recitation
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emeraldPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: const Text("Recite Ayah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (widget.onPlayAyah != null) {
                          widget.onPlayAyah!(ayah);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Copy Arabic
                  IconButton.filledTonal(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: ayah.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Copied Ayah ${ayah.numberInSurah} to clipboard"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),

                  // Share
                  IconButton.filledTonal(
                    icon: const Icon(Icons.share_rounded, size: 18),
                    onPressed: () {
                      Share.share(
                        "${ayah.text}\n\n\"${ayah.translation}\"\n\n— Surah ${widget.surah.englishName} [${widget.surah.number}:${ayah.numberInSurah}]",
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (mounted) setState(() => _selectedAyah = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ayahs.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.goldWarm));
    }

    final firstAyah = widget.ayahs.first;
    final juzNum = firstAyah.juz > 0 ? firstAyah.juz : 1;
    final juzTitle = "الجُزْءُ ${toArabicDigits(juzNum)}";
    final surahTitle = "سُورَةُ ${widget.surah.name}";

    return MushafPageBorder(
      borderColor: _borderColor,
      backgroundColor: _bgColor,
      surahTitle: surahTitle,
      juzTitle: juzTitle,
      pageNumber: firstAyah.page > 0 ? firstAyah.page : widget.surah.number,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          children: [
            // Traditional Surah Cartouche Banner
            SurahCartoucheHeader(
              surahNameArabic: widget.surah.name,
              revelationType: widget.surah.revelationType,
              numberOfAyahs: widget.surah.numberOfAyahs,
              borderColor: _borderColor,
              textColor: _textColor,
              isDark: _isDark,
            ),

            // Calligraphic Bismillah Banner (except Surah At-Tawbah 9)
            if (widget.surah.number != 9)
              BismillahBanner(
                textColor: _textColor,
                borderColor: _borderColor,
              ),

            const SizedBox(height: 12),

            // Continuous Flowing Justified Quranic Text (Madani Mushaf Layout)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text.rich(
                TextSpan(
                  children: _buildFlowingAyahs(),
                ),
                textAlign: widget.surah.numberOfAyahs <= 10 ? TextAlign.center : TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _buildFlowingAyahs() {
    final List<InlineSpan> spans = [];

    for (int i = 0; i < widget.ayahs.length; i++) {
      final ayah = widget.ayahs[i];
      final isSelected = _selectedAyah?.number == ayah.number;
      final isPlaying = widget.currentlyPlayingAyah?.number == ayah.number;

      // Clean Bismillah prefix from Ayah 1 if it's not Surah Al-Fatiha
      String cleanText = ayah.text;
      if (widget.surah.number != 1 && widget.surah.number != 9 && ayah.numberInSurah == 1) {
        const bismillah1 = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";
        const bismillah2 = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";
        if (cleanText.startsWith(bismillah1)) {
          cleanText = cleanText.substring(bismillah1.length).trim();
        } else if (cleanText.startsWith(bismillah2)) {
          cleanText = cleanText.substring(bismillah2.length).trim();
        }
      }

      // Verse Text Span with clickable gesture
      spans.add(
        TextSpan(
          text: "$cleanText ",
          style: GoogleFonts.amiriQuran(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.normal,
            color: isPlaying
                ? AppColors.emeraldLight
                : (isSelected
                    ? AppColors.goldWarm
                    : _textColor),
            backgroundColor: isPlaying
                ? AppColors.emeraldPrimary.withOpacity(0.18)
                : (isSelected ? AppColors.goldWarm.withOpacity(0.2) : Colors.transparent),
            height: 2.5,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _showAyahDetailsSheet(context, ayah),
        ),
      );

      // Ornate Quranic End of Ayah Rosette Marker
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () => _showAyahDetailsSheet(context, ayah),
            child: AyahRosetteMarker(
              verseNumber: ayah.numberInSurah,
              color: isPlaying ? AppColors.emeraldPrimary : _borderColor,
              size: widget.fontSize * 1.18,
            ),
          ),
        ),
      );

      // Spacing between ayahs
      spans.add(const TextSpan(text: " "));
    }

    return spans;
  }
}
