import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/sources/local_hadiths_data.dart';

class DailyCardsCarousel extends StatefulWidget {
  const DailyCardsCarousel({super.key});

  @override
  State<DailyCardsCarousel> createState() => _DailyCardsCarouselState();
}

class _DailyCardsCarouselState extends State<DailyCardsCarousel> {
  bool _isHadithTab = true;
  int _hadithIndex = 0;
  int _verseIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hadiths = LocalHadithsData.dailyHadiths;
    final verses = LocalHadithsData.dailyVerses;

    final currentData = _isHadithTab ? hadiths[_hadithIndex] : verses[_verseIndex];
    final total = _isHadithTab ? hadiths.length : verses.length;
    final currentIndex = _isHadithTab ? _hadithIndex : _verseIndex;

    final today = DateTime.now();
    final dayNum = today.day.toString();
    final monthName = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ][today.month - 1];

    return Column(
      children: [
        // Tab switcher
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTabButton("Hadith", _isHadithTab, () {
              setState(() => _isHadithTab = true);
            }),
            const SizedBox(width: 8),
            _buildTabButton("Verse", !_isHadithTab, () {
              setState(() => _isHadithTab = false);
            }),
          ],
        ),
        const SizedBox(height: 12),

        // Main Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E1B4B), Color(0xFF0F172A), Color(0xFF172554)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1B4B).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: AppColors.islamicGold.withOpacity(0.35), width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Date badge + title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                dayNum,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E1B4B),
                                  height: 1,
                                ),
                              ),
                              Text(
                                monthName,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD97706),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isHadithTab ? "✨ Hadith Of The Day" : "📖 Verse Of The Day",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFBBF24),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_rounded, color: Colors.white70, size: 20),
                      onPressed: () {
                        final shareText = "${currentData['text']}\n— ${currentData['source']}\n(via MyIslam)";
                        Share.share(shareText);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Optional Arabic text for verse or narrator for hadith
                if (!_isHadithTab && currentData.containsKey("arabic")) ...[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      currentData["arabic"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (_isHadithTab && currentData.containsKey("narrator")) ...[
                  Text(
                    "${currentData['narrator']}:",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],

                // Quote
                Text(
                  "\"${currentData['text']}\"",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 14),

                // Footer source & Carousel arrows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "— ${currentData['source']}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFCD34D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.chevron_left_rounded, color: Colors.white70, size: 22),
                          onPressed: () {
                            setState(() {
                              if (_isHadithTab) {
                                _hadithIndex = (_hadithIndex - 1 + hadiths.length) % hadiths.length;
                              } else {
                                _verseIndex = (_verseIndex - 1 + verses.length) % verses.length;
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${currentIndex + 1}/$total",
                          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6)),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 22),
                          onPressed: () {
                            setState(() {
                              if (_isHadithTab) {
                                _hadithIndex = (_hadithIndex + 1) % hadiths.length;
                              } else {
                                _verseIndex = (_verseIndex + 1) % verses.length;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.islamicGold : Colors.black12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
