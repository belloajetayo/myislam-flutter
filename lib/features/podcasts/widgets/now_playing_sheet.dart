import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/audio_service.dart';

class NowPlayingSheet extends StatelessWidget {
  const NowPlayingSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NowPlayingSheet(),
    );
  }

  void _showSpeedPicker(BuildContext context, AudioService audioService) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final speeds = [0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Playback Speed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: speeds.map((sp) {
                  final isCurrent = (audioService.playbackSpeed - sp).abs() < 0.05;
                  return ChoiceChip(
                    label: Text("${sp}x"),
                    selected: isCurrent,
                    selectedColor: AppColors.islamicGold,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    ),
                    onSelected: (_) {
                      audioService.setPlaybackSpeed(sp);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSleepTimerPicker(BuildContext context, AudioService audioService) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final options = [
          {"label": "Turn Off", "val": null},
          {"label": "15 Minutes", "val": 15},
          {"label": "30 Minutes", "val": 30},
          {"label": "45 Minutes", "val": 45},
          {"label": "60 Minutes", "val": 60},
        ];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sleep Timer",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...options.map((opt) {
                final val = opt["val"] as int?;
                final isCurrent = audioService.sleepTimerMinutes == val;

                return ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  tileColor: isCurrent ? AppColors.islamicGold.withOpacity(0.15) : null,
                  leading: Icon(
                    Icons.snooze_rounded,
                    color: isCurrent ? AppColors.islamicGold : Colors.grey,
                  ),
                  title: Text(
                    opt["label"] as String,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? AppColors.islamicGold : null,
                    ),
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.check_rounded, color: AppColors.islamicGold, size: 20)
                      : null,
                  onTap: () {
                    audioService.setSleepTimer(val);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioService = context.watch<AudioService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sheetHeight = MediaQuery.of(context).size.height * 0.78;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.6 : 0.25),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Top action bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  audioService.isLiveStream ? "LIVE BROADCAST" : (audioService.currentShowTitle ?? "ISLAMIC AUDIO"),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: AppColors.islamicGold,
                  ),
                ),
                if (audioService.currentEpisodeId != null)
                  IconButton(
                    icon: Icon(
                      audioService.isEpisodeSaved(audioService.currentEpisodeId!)
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: AppColors.islamicGold,
                    ),
                    onPressed: () => audioService.toggleSaveEpisode(audioService.currentEpisodeId!),
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Album Art / Icon Box
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.purpleGoldHeroGradient : AppColors.purpleGoldShiningGradient,
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: AppColors.islamicGold.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.islamicGold.withOpacity(isDark ? 0.35 : 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      audioService.currentIcon ?? (audioService.isLiveStream ? "📻" : "🎙️"),
                      style: const TextStyle(fontSize: 72),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Title and Subtitle
                  Text(
                    audioService.currentTitle ?? "Episode Title",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    audioService.currentSubtitle ?? (audioService.currentSpeaker ?? "Islamic Speaker"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 24),

                  // Progress Bar & Duration (for podcasts)
                  if (!audioService.isLiveStream) ...[
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        activeTrackColor: AppColors.islamicGold,
                        inactiveTrackColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                        thumbColor: AppColors.islamicGold,
                        overlayColor: AppColors.islamicGold.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: audioService.progressFraction,
                        onChanged: (val) {
                          if (audioService.duration.inMilliseconds > 0) {
                            final target = Duration(
                              milliseconds: (val * audioService.duration.inMilliseconds).toInt(),
                            );
                            audioService.seek(target);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            audioService.formattedPosition,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.grey[600],
                            ),
                          ),
                          Text(
                            audioService.formattedDuration,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Live Stream Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                          SizedBox(width: 8),
                          Text(
                            "LIVE AUDIO STREAM • 24/7",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Main Player Controls Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // -10s Rewind
                      IconButton(
                        iconSize: 34,
                        icon: const Icon(Icons.replay_10_rounded),
                        color: isDark ? Colors.white70 : Colors.black87,
                        onPressed: () => audioService.skipSeconds(-10),
                      ),
                      const SizedBox(width: 20),

                      // Play/Pause Button
                      GestureDetector(
                        onTap: () => audioService.togglePlayPause(),
                        child: Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            gradient: AppColors.purpleGoldShiningGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.islamicGold.withOpacity(0.4),
                                blurRadius: 18,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: audioService.isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                  ),
                                )
                              : Icon(
                                  audioService.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 38,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // +30s Fast Forward
                      IconButton(
                        iconSize: 34,
                        icon: const Icon(Icons.forward_30_rounded),
                        color: isDark ? Colors.white70 : Colors.black87,
                        onPressed: () => audioService.skipSeconds(30),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Secondary Toolbar: Speed & Sleep Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Playback Speed Button
                      ActionChip(
                        avatar: const Icon(Icons.speed_rounded, size: 14),
                        label: Text("${audioService.playbackSpeed}x"),
                        backgroundColor: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9),
                        onPressed: () => _showSpeedPicker(context, audioService),
                      ),
                      const SizedBox(width: 14),

                      // Sleep Timer Button
                      ActionChip(
                        avatar: Icon(
                          Icons.snooze_rounded,
                          size: 14,
                          color: audioService.sleepTimerMinutes != null ? AppColors.islamicGold : null,
                        ),
                        label: Text(
                          audioService.sleepTimerMinutes != null
                              ? "${audioService.sleepTimerMinutes}m"
                              : "Sleep Timer",
                          style: TextStyle(
                            color: audioService.sleepTimerMinutes != null ? AppColors.islamicGold : null,
                            fontWeight: audioService.sleepTimerMinutes != null ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        backgroundColor: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9),
                        onPressed: () => _showSleepTimerPicker(context, audioService),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
