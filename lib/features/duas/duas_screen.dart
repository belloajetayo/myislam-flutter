import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/models/dua_model.dart';
import '../../data/sources/local_duas_data.dart';
import '../../data/services/storage_service.dart';
import 'dua_detail_screen.dart';
import 'widgets/dua_card.dart';
import 'widgets/dua_category_card.dart';

class DuasScreen extends StatefulWidget {
  final VoidCallback onBack;

  const DuasScreen({super.key, required this.onBack});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  String _selectedCategoryId = "after-salah";
  bool _isGridView = false; // Grid of chapters vs List of duas
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final Map<String, int> _counts = {};
  late AudioPlayer _audioPlayer;
  String? _playingAudioUrl;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted && state == PlayerState.completed) {
        setState(() {
          _playingAudioUrl = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio(String url) async {
    try {
      if (_playingAudioUrl == url) {
        await _audioPlayer.stop();
        setState(() {
          _playingAudioUrl = null;
        });
      } else {
        await _audioPlayer.stop();
        setState(() {
          _playingAudioUrl = url;
        });
        await _audioPlayer.play(UrlSource(url));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _playingAudioUrl = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Audio unavailable offline"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openDetailScreen(List<DuaItem> duas, int initialIndex, String title) {
    if (_playingAudioUrl != null) {
      _audioPlayer.stop();
      setState(() {
        _playingAudioUrl = null;
      });
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DuaDetailScreen(
          duas: duas,
          initialIndex: initialIndex,
          categoryTitle: title,
        ),
      ),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        final isDark = Theme.of(modalContext).brightness == Brightness.dark;
        return Consumer<StorageService>(
          builder: (context, storage, child) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Display & Typography",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),

                  // Font Size Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Arabic Font Size", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(
                        "${storage.arabicFontSize.toInt()} pt",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                      ),
                    ],
                  ),
                  Slider(
                    value: storage.arabicFontSize,
                    min: 18.0,
                    max: 38.0,
                    divisions: 10,
                    activeColor: AppColors.islamicGold,
                    inactiveColor: Colors.grey.withValues(alpha: 0.3),
                    onChanged: (val) {
                      storage.setArabicFontSize(val);
                    },
                  ),

                  const Divider(height: 20),

                  // Transliteration Switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Show Transliteration", style: TextStyle(fontSize: 14)),
                    activeThumbColor: AppColors.islamicGold,
                    value: storage.showTransliteration,
                    onChanged: (_) => storage.toggleTransliteration(),
                  ),

                  // Translation Switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Show Translation", style: TextStyle(fontSize: 14)),
                    activeThumbColor: AppColors.islamicGold,
                    value: storage.showTranslation,
                    onChanged: (_) => storage.toggleTranslation(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storage = context.watch<StorageService>();
    const categories = LocalDuasData.categories;

    // Determine current list of Duas
    List<DuaItem> displayDuas;
    String screenTitle;

    if (_searchQuery.trim().isNotEmpty) {
      displayDuas = LocalDuasData.searchDuas(_searchQuery);
      screenTitle = "Search: '$_searchQuery' (${displayDuas.length})";
    } else if (_selectedCategoryId == "favorites") {
      displayDuas = LocalDuasData.getFavoriteDuas(storage.favoriteDuaIds);
      screenTitle = "Favorite Duas (${displayDuas.length})";
    } else {
      displayDuas = LocalDuasData.duasMap[_selectedCategoryId] ?? [];
      final activeCat = categories.firstWhere(
        (c) => c.id == _selectedCategoryId,
        orElse: () => categories.first,
      );
      screenTitle = activeCat.name;
    }

    return SafeArea(
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(
              children: [
                AnimatedBackButton(
                  onPressed: widget.onBack,
                  tooltip: "Back to Home",
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Duas & Azkar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.islamicGold,
                        ),
                      ),
                      Text(
                        "Hisnul Muslim • Authentic Supplications",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Grid / List Toggle Button
                IconButton(
                  icon: Icon(
                    _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                  tooltip: _isGridView ? "List View" : "Chapters Grid",
                  onPressed: () {
                    setState(() {
                      _isGridView = !_isGridView;
                      _searchQuery = "";
                      _searchController.clear();
                    });
                  },
                ),

                // Typography & Reading Settings
                IconButton(
                  icon: Icon(
                    Icons.format_size_rounded,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                  tooltip: "Text Settings",
                  onPressed: () => _showSettingsModal(context),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Duas, English, Arabic, Reference...",
                  hintStyle: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchQuery = "";
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // Time-Aware Recommended Routine Banner
          if (_searchQuery.isEmpty && !_isGridView)
            _buildRoutineBanner(isDark),

          // Categories Horizontal Chips Bar (When not searching and not in grid view)
          if (_searchQuery.isEmpty && !_isGridView)
            SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  // Favorites Pill
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = "favorites";
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: _selectedCategoryId == "favorites"
                            ? AppColors.goldGradient
                            : null,
                        color: _selectedCategoryId == "favorites"
                            ? null
                            : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedCategoryId == "favorites"
                              ? Colors.transparent
                              : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: _selectedCategoryId == "favorites" ? Colors.white : AppColors.islamicGold,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Favorites (${storage.favoriteDuaIds.length})",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedCategoryId == "favorites" ? FontWeight.bold : FontWeight.w500,
                              color: _selectedCategoryId == "favorites"
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Chapters Pills
                  ...categories.map((cat) {
                    final isSelected = cat.id == _selectedCategoryId;
                    final colors = cat.gradientColors.map((c) => Color(c)).toList();

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = cat.id;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: colors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isSelected ? null : (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cat.icon, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

          const SizedBox(height: 4),

          // Main View: Grid of Chapters OR List of Duas
          Expanded(
            child: _isGridView && _searchQuery.isEmpty
                // Grid of Chapters Mode
                ? GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = cat.id == _selectedCategoryId;

                      return DuaCategoryCard(
                        category: cat,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = cat.id;
                            _isGridView = false; // Switch to list view of this chapter
                          });
                        },
                      );
                    },
                  )
                // List of Duas Mode
                : displayDuas.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _selectedCategoryId == "favorites"
                                    ? Icons.star_border_rounded
                                    : Icons.search_off_rounded,
                                size: 54,
                                color: Colors.grey.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _selectedCategoryId == "favorites"
                                    ? "No favorite duas saved yet.\nTap the star icon on any dua to bookmark it!"
                                    : "No duas found matching '$_searchQuery'.\nTry searching for 'forgiveness', 'sleep', 'salah', or 'rabbana'.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 13.5, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                        itemCount: displayDuas.length,
                        itemBuilder: (context, index) {
                          final dua = displayDuas[index];
                          final count = _counts[dua.id] ?? 0;

                          return DuaCard(
                            dua: dua,
                            count: count,
                            onIncrement: () {
                              setState(() {
                                _counts[dua.id] = count + 1;
                              });
                              storage.incrementDuas();
                            },
                            onReset: () {
                              setState(() {
                                _counts[dua.id] = 0;
                              });
                            },
                            onOpenDetail: () {
                              _openDetailScreen(displayDuas, index, screenTitle);
                            },
                            isAudioPlaying: _playingAudioUrl == dua.audioUrl,
                            onToggleAudio: () {
                              if (dua.audioUrl != null) {
                                _toggleAudio(dua.audioUrl!);
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineBanner(bool isDark) {
    final hour = DateTime.now().hour;
    String routineId;
    String routineTitle;
    String routineSubtitle;
    String icon;
    List<Color> gradientColors;

    if (hour >= 4 && hour < 12) {
      routineId = "morning";
      routineTitle = "Morning Adhkar Routine";
      routineSubtitle = "Shield yourself from Fajr till Dhuhr";
      icon = "🌅";
      gradientColors = const [Color(0xFFF59E0B), Color(0xFFD97706)];
    } else if (hour >= 15 && hour < 20) {
      routineId = "evening";
      routineTitle = "Evening Adhkar Routine";
      routineSubtitle = "Fortress of the believer from Asr till Night";
      icon = "🌆";
      gradientColors = const [Color(0xFF8B5CF6), Color(0xFF6D28D9)];
    } else {
      routineId = "after-salah";
      routineTitle = "Post-Prayer & Night Remembrances";
      routineSubtitle = "Essential Tasbeeh & Ayatul Kursi";
      icon = "✨";
      gradientColors = const [Color(0xFF10B981), Color(0xFF047857)];
    }

    final routineDuas = LocalDuasData.duasMap[routineId] ?? [];
    if (routineDuas.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [gradientColors[0].withOpacity(0.3), gradientColors[1].withOpacity(0.15)]
              : [gradientColors[0].withOpacity(0.12), gradientColors[1].withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gradientColors[0].withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      routineTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: gradientColors[0].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Now",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: gradientColors[0],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  routineSubtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: gradientColors[0],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              _openDetailScreen(routineDuas, 0, routineTitle);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Start", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.play_arrow_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

