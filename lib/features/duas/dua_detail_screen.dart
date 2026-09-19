import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/models/dua_model.dart';
import '../../data/services/storage_service.dart';

class DuaDetailScreen extends StatefulWidget {
  final List<DuaItem> duas;
  final int initialIndex;
  final String categoryTitle;

  const DuaDetailScreen({
    super.key,
    required this.duas,
    required this.initialIndex,
    required this.categoryTitle,
  });

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final Map<String, int> _counts = {};
  late AudioPlayer _audioPlayer;
  bool _isPlayingAudio = false;
  String? _activeAudioUrl;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlayingAudio = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
          _activeAudioUrl = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio(String url) async {
    try {
      if (_isPlayingAudio && _activeAudioUrl == url) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.stop();
        _activeAudioUrl = url;
        await _audioPlayer.play(UrlSource(url));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Audio playback unavailable offline"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
                    "Reader & Typography Settings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),

                  // Font size slider
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

                  const Divider(height: 24),

                  // Transliteration switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Show Transliteration (Pronunciation)", style: TextStyle(fontSize: 14)),
                    activeThumbColor: AppColors.islamicGold,
                    value: storage.showTransliteration,
                    onChanged: (_) => storage.toggleTransliteration(),
                  ),

                  // Translation switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Show English Translation", style: TextStyle(fontSize: 14)),
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
    final currentDua = widget.duas[_currentIndex];
    final isFavorite = storage.isFavoriteDua(currentDua.id);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0C29) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Center(
          child: AnimatedBackButton(
            size: 38,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Column(
          children: [
            Text(
              widget.categoryTitle,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              "Dua ${_currentIndex + 1} of ${widget.duas.length}",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite ? AppColors.islamicGold : null,
            ),
            tooltip: "Favorite",
            onPressed: () {
              storage.toggleFavoriteDua(currentDua.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_fields_rounded),
            tooltip: "Reading Settings",
            onPressed: () => _showSettingsModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Page View of Duas
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.duas.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                if (_isPlayingAudio) {
                  _audioPlayer.stop();
                }
              },
              itemBuilder: (context, index) {
                final dua = widget.duas[index];
                final count = _counts[dua.id] ?? 0;
                final isCompleted = count >= dua.targetCount;
                final progress = dua.targetCount > 0
                    ? (count / dua.targetCount).clamp(0.0, 1.0)
                    : 1.0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Card with Title & Target
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dua.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (dua.subTitle != null)
                                    Text(
                                      dua.subTitle!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? const Color(0xFF10B981).withValues(alpha: 0.2)
                                    : AppColors.islamicGold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                isCompleted ? "Completed" : "Target: ${dua.targetCount}x",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted ? const Color(0xFF10B981) : AppColors.islamicGold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Audio Pronunciation Player Bar (if available)
                      if (dua.audioUrl != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                                  : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.islamicGold.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _toggleAudio(dua.audioUrl!),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.goldGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isPlayingAudio && _activeAudioUrl == dua.audioUrl
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isPlayingAudio && _activeAudioUrl == dua.audioUrl
                                          ? "Playing Authentic Pronunciation..."
                                          : "Listen to Pronunciation",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Hisnul Muslim Recitation",
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.graphic_eq_rounded, color: AppColors.islamicGold, size: 24),
                            ],
                          ),
                        ),

                      // Arabic Container
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              dua.arabic,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: storage.arabicFontSize,
                                fontWeight: FontWeight.bold,
                                height: 2.0,
                                color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                              ),
                            ),

                            // Transliteration
                            if (storage.showTransliteration && dua.transliteration.isNotEmpty) ...[
                              const Divider(height: 28),
                              Text(
                                dua.transliteration,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  height: 1.45,
                                  color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                                ),
                              ),
                            ],

                            // Translation
                            if (storage.showTranslation) ...[
                              const SizedBox(height: 12),
                              Text(
                                "\"${dua.translation}\"",
                                style: TextStyle(
                                  fontSize: 14.5,
                                  height: 1.5,
                                  color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
                                ),
                              ),
                            ],

                            const SizedBox(height: 16),

                            // Reference
                            Text(
                              "— ${dua.reference}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Benefit & Virtue Card
                      if (dua.benefit != null && dua.benefit!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.islamicGold.withValues(alpha: isDark ? 0.08 : 0.06),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.islamicGold.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.auto_awesome_rounded, color: AppColors.islamicGold, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Virtue & Hadith Benefit",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.islamicGold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dua.benefit!,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        height: 1.45,
                                        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Interactive Tasbeeh Tap Dial
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            final newCount = count + 1;
                            setState(() {
                              _counts[dua.id] = newCount;
                            });
                            storage.incrementDuas();

                            // If target reached
                            if (newCount == dua.targetCount) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Masha'Allah! Repetition Target Reached! 🎉"),
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isCompleted
                                  ? const LinearGradient(
                                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : AppColors.goldGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: (isCompleted ? const Color(0xFF10B981) : AppColors.islamicGold)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Circular Progress Ring
                                SizedBox(
                                  width: 154,
                                  height: 154,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),

                                // Counter Text
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isCompleted ? Icons.check_rounded : Icons.touch_app_rounded,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$count",
                                      style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "of ${dua.targetCount}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withValues(alpha: 0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Tap hint & Reset button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (count > 0)
                            TextButton.icon(
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text("Reset Count", style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _counts[dua.id] = 0;
                                });
                              },
                            ),
                          TextButton.icon(
                            icon: const Icon(Icons.share_rounded, size: 16),
                            label: const Text("Share Dua", style: TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.islamicGold,
                            ),
                            onPressed: () {
                              Share.share(
                                "${dua.title}\n\n${dua.arabic}\n\n${dua.transliteration}\n\n\"${dua.translation}\"\n\n— ${dua.reference}\n(via MyIslam Duas & Azkar)",
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Navigation Row: Prev / Next
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1B4B).withValues(alpha: 0.8) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                  label: const Text("Previous"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9),
                    foregroundColor: isDark ? Colors.white : const Color(0xFF1E293B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _currentIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),

                // Page count
                Text(
                  "${_currentIndex + 1} / ${widget.duas.length}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),

                // Next button
                ElevatedButton.icon(
                  label: const Text("Next"),
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.islamicGold,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _currentIndex < widget.duas.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
