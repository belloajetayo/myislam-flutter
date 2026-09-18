import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/quran_models.dart';
import '../../data/services/quran_service.dart';
import '../../data/sources/local_hadiths_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'surah_reader_screen.dart';

class QuranScreen extends StatefulWidget {
  final VoidCallback onBack;

  const QuranScreen({super.key, required this.onBack});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quranService = context.watch<QuranService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredSurahs = quranService.surahs.where((s) {
      final q = _searchQuery.toLowerCase();
      return s.englishName.toLowerCase().contains(q) ||
          s.englishNameTranslation.toLowerCase().contains(q) ||
          s.number.toString() == q;
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  "The Holy Quran",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                hintText: "Search Surah name or number...",
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppColors.islamicGold,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.islamicGold,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Surahs"),
              Tab(text: "Hadith"),
              Tab(text: "Duas"),
              Tab(text: "Prophets"),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Surahs Tab
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  itemCount: filteredSurahs.length,
                  itemBuilder: (context, index) {
                    final surah = filteredSurahs[index];
                    return _buildSurahTile(surah, isDark);
                  },
                ),

                // 2. Hadith Tab
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  children: LocalHadithsData.categories.map((cat) {
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(cat.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(cat.categoryArabic, style: const TextStyle(fontFamily: 'Amiri', fontSize: 16, color: AppColors.islamicGold)),
                            ],
                          ),
                          const Divider(height: 20),
                          ...cat.hadiths.map((h) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    h.arabic,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("\"${h.translation}\"", style: const TextStyle(fontSize: 13, height: 1.4)),
                                  const SizedBox(height: 4),
                                  Text("— ${h.source}", style: const TextStyle(fontSize: 11, color: Color(0xFFF59E0B), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // 3. Duas Quick Links
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  children: const [
                    ListTile(
                      leading: Icon(Icons.bookmark_added_rounded, color: AppColors.islamicIndigo),
                      title: Text("40 Rabbana Duas"),
                      subtitle: Text("Supplications directly from the Holy Quran"),
                    ),
                    ListTile(
                      leading: Icon(Icons.shield_rounded, color: AppColors.islamicGreen),
                      title: Text("Ruquiya & Protection"),
                      subtitle: Text("Ayat al-Kursi, Al-Falaq, and An-Nas"),
                    ),
                  ],
                ),

                // 4. Prophets Tab
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  children: const [
                    ListTile(
                      leading: Text("🌟", style: TextStyle(fontSize: 22)),
                      title: Text("Prophet Muhammad ﷺ"),
                      subtitle: Text("The Seal of the Prophets, Messenger of Mercy"),
                    ),
                    ListTile(
                      leading: Text("✨", style: TextStyle(fontSize: 22)),
                      title: Text("Prophet Ibrahim (Abraham) عَلَيْهِ ٱلسَّلَامُ"),
                      subtitle: Text("Friend of Allah, Father of the Prophets"),
                    ),
                    ListTile(
                      leading: Text("🌊", style: TextStyle(fontSize: 22)),
                      title: Text("Prophet Musa (Moses) عَلَيْهِ ٱلسَّلَامُ"),
                      subtitle: Text("The one who spoke directly to Allah (Kalimullah)"),
                    ),
                    ListTile(
                      leading: Text("🕊️", style: TextStyle(fontSize: 22)),
                      title: Text("Prophet Isa (Jesus) عَلَيْهِ ٱلسَّلَامُ"),
                      subtitle: Text("Word from Allah and a Spirit from Him"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahTile(Surah surah, bool isDark) {
    final isMeccan = surah.revelationType.toLowerCase().contains("meccan");

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SurahReaderScreen(surah: surah)),
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: isMeccan
                ? const LinearGradient(colors: [Color(0xFF065F46), Color(0xFF047857)])
                : const LinearGradient(colors: [Color(0xFFB45309), Color(0xFFD97706)]),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: (isMeccan ? AppColors.emeraldPrimary : AppColors.goldWarm).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            "${surah.number}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
        ),
        title: Row(
          children: [
            Text(surah.englishName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isMeccan ? "🕋 Makkah" : "🕌 Madinah",
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ),
          ],
        ),
        subtitle: Text(
          "${surah.englishNameTranslation} • ${surah.numberOfAyahs} Verses",
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: Text(
          surah.name,
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.goldLight : AppColors.goldOchre,
          ),
        ),
      ),
    );
  }
}
