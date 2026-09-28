import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  static const List<String> _bgImages = [
    "https://images.unsplash.com/photo-1542816417-0983c9c9ad53?w=800&q=80",
    "https://images.unsplash.com/photo-1564769662533-4f00a87b4056?w=800&q=80",
    "https://images.unsplash.com/photo-1519817914152-22d216bb9170?w=800&q=80",
    "https://images.unsplash.com/photo-1609599006353-e629aaabfeae?w=800&q=80",
    "https://images.unsplash.com/photo-1597975020386-f8e85b6e8e0b?w=800&q=80",
  ];

  @override
  Widget build(BuildContext context) {
    const hadiths = LocalHadithsData.dailyHadiths;
    const verses = LocalHadithsData.dailyVerses;

    final currentData = _isHadithTab ? hadiths[_hadithIndex] : verses[_verseIndex];
    final total = _isHadithTab ? hadiths.length : verses.length;
    final currentIndex = _isHadithTab ? _hadithIndex : _verseIndex;
    final bgUrl = _bgImages[currentIndex % _bgImages.length];

    final today = DateTime.now();
    final dayNum = today.day.toString();
    final monthName = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ][today.month - 1];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Share & Download
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Daily Inspiration",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 18, color: Color(0xFFF59E0B)),
                    onPressed: () {
                      final shareText = "${currentData['text']}\n— ${currentData['source']}\n(via MyIslam App)";
                      Share.share(shareText);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFFF59E0B)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Inspiration saved to bookmarks! ✅")),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Segmented Tabs: Hadith | Verse
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isHadithTab = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _isHadithTab ? const Color(0xFFF59E0B) : (isDark ? Colors.white10 : Colors.white),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _isHadithTab
                        ? [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: _isHadithTab
                          ? Colors.transparent
                          : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 14,
                        color: _isHadithTab ? Colors.white : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Hadith",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _isHadithTab ? Colors.white : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isHadithTab = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: !_isHadithTab ? const Color(0xFF6366F1) : (isDark ? Colors.white10 : Colors.white),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: !_isHadithTab
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: !_isHadithTab
                          ? Colors.transparent
                          : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 14,
                        color: !_isHadithTab ? Colors.white : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Verse",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: !_isHadithTab ? Colors.white : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Main Inspiration Card with photo background
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: double.infinity,
            height: 310,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.network(
                  bgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1E1B4B), Color(0xFF0F172A), Color(0xFF172554)],
                      ),
                    ),
                  ),
                ),

                // Dark multi-stop gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.35),
                        Colors.black.withOpacity(0.60),
                        Colors.black.withOpacity(0.90),
                      ],
                    ),
                  ),
                ),

                // Top golden accent border line
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      ),
                    ),
                  ),
                ),

                // Top Content: Date Badge + Title
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    children: [
                      // Date Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              dayNum,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
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
                      const SizedBox(width: 10),
                      Text(
                        _isHadithTab ? "✨ Hadith Of The Day" : "✨ Quranic Verse",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFBBF24),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Content: Quote + Source + MyIslam branding
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isHadithTab && currentData.containsKey("narrator"))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "${currentData['narrator']}:",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        ),

                      if (!_isHadithTab && currentData.containsKey("arabic"))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            currentData["arabic"]!,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.amiriQuran(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.6,
                            ),
                          ),
                        ),

                      Text(
                        "\"${currentData['text']}\"",
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.45,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      Text(
                        "[${currentData['source']}]",
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFFCD34D),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Brand Footer
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Center(
                              child: Text("م", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "MyIslam.App",
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Left Arrow Button
                Positioned(
                  left: 8,
                  top: 130,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_isHadithTab) {
                          _hadithIndex = (_hadithIndex - 1 + hadiths.length) % hadiths.length;
                        } else {
                          _verseIndex = (_verseIndex - 1 + verses.length) % verses.length;
                        }
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),

                // Right Arrow Button
                Positioned(
                  right: 8,
                  top: 130,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_isHadithTab) {
                          _hadithIndex = (_hadithIndex + 1) % hadiths.length;
                        } else {
                          _verseIndex = (_verseIndex + 1) % verses.length;
                        }
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Pagination Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(total.clamp(0, 10), (i) {
            final active = i == (currentIndex % 10);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: active
                    ? (_isHadithTab ? const Color(0xFFF59E0B) : const Color(0xFF6366F1))
                    : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
              ),
            );
          }),
        ),
      ],
    );
  }
}
