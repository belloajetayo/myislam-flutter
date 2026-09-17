import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/audio_service.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = context.watch<AudioService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!audioService.hasTrack) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.islamicGold.withOpacity(0.3) : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.headphones_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  audioService.currentTitle ?? "Audio Playing",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  audioService.currentSubtitle ?? "Streaming",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (audioService.isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.islamicGold),
            )
          else
            IconButton(
              icon: Icon(
                audioService.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                color: AppColors.islamicGold,
                size: 32,
              ),
              onPressed: () => audioService.togglePlayPause(),
            ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: isDark ? Colors.white60 : Colors.black45,
            ),
            onPressed: () => audioService.stop(),
          ),
        ],
      ),
    );
  }
}
