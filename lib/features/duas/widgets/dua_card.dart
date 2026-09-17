import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/dua_model.dart';
import '../../../data/services/storage_service.dart';

class DuaCard extends StatefulWidget {
  final DuaItem dua;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onReset;
  final VoidCallback onOpenDetail;
  final bool isAudioPlaying;
  final VoidCallback onToggleAudio;

  const DuaCard({
    super.key,
    required this.dua,
    required this.count,
    required this.onIncrement,
    required this.onReset,
    required this.onOpenDetail,
    required this.isAudioPlaying,
    required this.onToggleAudio,
  });

  @override
  State<DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<DuaCard> {
  bool _showVirtue = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storage = context.watch<StorageService>();
    final isFavorite = storage.isFavoriteDua(widget.dua.id);
    final isCompleted = widget.count >= widget.dua.targetCount;
    final progress = widget.dua.targetCount > 0
        ? (widget.count / widget.dua.targetCount).clamp(0.0, 1.0)
        : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF10B981)
              : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFEEF2FF)),
          width: isCompleted ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isCompleted
                ? const Color(0xFF10B981).withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onOpenDetail,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Action Bar
                Row(
                  children: [
                    // Target repetition chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFF10B981).withValues(alpha: 0.15)
                            : AppColors.islamicGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle_rounded : Icons.repeat_rounded,
                            size: 13,
                            color: isCompleted ? const Color(0xFF10B981) : AppColors.islamicGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCompleted ? "Completed" : "Repeat ${widget.dua.targetCount}x",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? const Color(0xFF10B981) : AppColors.islamicGold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Audio Pronunciation Button
                    if (widget.dua.audioUrl != null)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: widget.isAudioPlaying
                                ? AppColors.islamicGold
                                : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9)),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isAudioPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                            size: 16,
                            color: widget.isAudioPlaying
                                ? Colors.white
                                : (isDark ? Colors.white70 : const Color(0xFF475569)),
                          ),
                        ),
                        tooltip: "Pronunciation Audio",
                        onPressed: widget.onToggleAudio,
                      ),

                    // Favorite Button
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 20,
                        color: isFavorite ? AppColors.islamicGold : Colors.grey,
                      ),
                      tooltip: isFavorite ? "Remove Favorite" : "Add Favorite",
                      onPressed: () {
                        storage.toggleFavoriteDua(widget.dua.id);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorite ? "Removed from Favorites" : "Saved to Favorites ⭐",
                              style: const TextStyle(fontSize: 12),
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),

                    // Share Button
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.share_rounded, size: 18, color: Colors.grey),
                      tooltip: "Share Dua",
                      onPressed: () {
                        final shareText = "${widget.dua.title}\n\n"
                            "${widget.dua.arabic}\n\n"
                            "${widget.dua.transliteration}\n\n"
                            "\"${widget.dua.translation}\"\n\n"
                            "— ${widget.dua.reference}\n"
                            "(via MyIslam Duas & Azkar)";
                        Share.share(shareText);
                      },
                    ),

                    // Copy Button
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.copy_rounded, size: 17, color: Colors.grey),
                      tooltip: "Copy Text",
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                          text: "${widget.dua.arabic}\n\n${widget.dua.translation}\n— ${widget.dua.reference}",
                        ));
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Copied to clipboard! 📋", style: TextStyle(fontSize: 12)),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Title & Subtitle
                Text(
                  widget.dua.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                if (widget.dua.subTitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.dua.subTitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // Arabic Text
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Text(
                    widget.dua.arabic,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: storage.arabicFontSize,
                      fontWeight: FontWeight.bold,
                      height: 1.9,
                      color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                    ),
                  ),
                ),

                // Transliteration
                if (storage.showTransliteration && widget.dua.transliteration.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.dua.transliteration,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
                      ),
                    ),
                  ),
                ],

                // Translation
                if (storage.showTranslation) ...[
                  const SizedBox(height: 10),
                  Text(
                    "\"${widget.dua.translation}\"",
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.45,
                      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
                    ),
                  ),
                ],

                // Benefit & Virtue Expandable Tile
                if (widget.dua.benefit != null && widget.dua.benefit!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showVirtue = !_showVirtue;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.islamicGold.withValues(alpha: isDark ? 0.08 : 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.islamicGold.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.islamicGold),
                              const SizedBox(width: 6),
                              const Text(
                                "Virtue & Hadith Benefit",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.islamicGold,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                _showVirtue ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: AppColors.islamicGold,
                              ),
                            ],
                          ),
                          if (_showVirtue) ...[
                            const SizedBox(height: 6),
                            Text(
                              widget.dua.benefit!,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: isDark ? AppColors.darkTextPrimary : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // Bottom Footer: Reference & Interactive Tasbeeh Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reference
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.bookmark_added_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.dua.reference,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Reset button (if count > 0)
                    if (widget.count > 0)
                      GestureDetector(
                        onTap: widget.onReset,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.refresh_rounded, size: 14, color: Colors.grey),
                        ),
                      ),

                    // Tap Counter Button
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        widget.onIncrement();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: isCompleted
                              ? const LinearGradient(
                                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (isCompleted ? const Color(0xFF10B981) : AppColors.islamicGold)
                                  .withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCompleted ? Icons.check_circle_rounded : Icons.fingerprint_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${widget.count} / ${widget.dua.targetCount}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Mini Progress Bar when counting
                if (widget.count > 0) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3.5,
                      backgroundColor: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted ? const Color(0xFF10B981) : AppColors.islamicGold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
