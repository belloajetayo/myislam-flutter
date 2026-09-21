import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'mia_astra_3d_orb.dart';

class Mia3dCompanionStage extends StatefulWidget {
  final MiaOrbState state;
  final Function(String prompt) onSelectPrompt;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const Mia3dCompanionStage({
    super.key,
    required this.state,
    required this.onSelectPrompt,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  State<Mia3dCompanionStage> createState() => _Mia3dCompanionStageState();
}

class _Mia3dCompanionStageState extends State<Mia3dCompanionStage>
    with SingleTickerProviderStateMixin {
  late AnimationController _satelliteController;

  final List<_SatellitePrompt> _prompts = [
    _SatellitePrompt(
      label: "🤲 Dua for Peace",
      prompt: "🤲 Dua for peace & anxiety",
      icon: Icons.favorite_rounded,
      color: AppColors.astraSkyLight,
      speedOffset: 0.0,
    ),
    _SatellitePrompt(
      label: "📖 Surah Al-Mulk",
      prompt: "📖 Virtues of Surah Al-Mulk",
      icon: Icons.menu_book_rounded,
      color: AppColors.astraGoldLight,
      speedOffset: 0.25,
    ),
    _SatellitePrompt(
      label: "🧭 App Tour",
      prompt: "🧭 App Tour & Guide",
      icon: Icons.explore_rounded,
      color: AppColors.astraPurple,
      speedOffset: 0.50,
    ),
    _SatellitePrompt(
      label: "🕋 Prayer Times",
      prompt: "🕋 How to find Qiblah & Prayer times?",
      icon: Icons.mosque_rounded,
      color: AppColors.astraSkyCyan,
      speedOffset: 0.75,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _satelliteController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _satelliteController.dispose();
    super.dispose();
  }

  String _getStateTitle() {
    switch (widget.state) {
      case MiaOrbState.idle:
        return "MIA ASTRA 3D • READY & PEACEFUL";
      case MiaOrbState.listening:
        return "MIA ASTRA 3D • LISTENING ATTENTIVELY";
      case MiaOrbState.thinking:
        return "MIA ASTRA 3D • SEARCHING QURAN & SUNNAH";
      case MiaOrbState.speaking:
        return "MIA ASTRA 3D • SHARING KNOWLEDGE";
    }
  }

  Color _getStateColor() {
    switch (widget.state) {
      case MiaOrbState.idle:
        return AppColors.astraSkyLight;
      case MiaOrbState.listening:
        return AppColors.astraGoldLight;
      case MiaOrbState.thinking:
        return AppColors.astraGold;
      case MiaOrbState.speaking:
        return AppColors.astraPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!widget.isExpanded) {
      // Compact 3D Mode Bar
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.astraSkyLight.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            MiaAstra3dOrb(
              size: 40,
              state: widget.state,
              interactive: false,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getStateTitle(),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: _getStateColor(),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const Text(
                    "Tap expand for 3D orbital satellites & gestures",
                    style: TextStyle(fontSize: 9.5, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_full_rounded, size: 18),
              color: AppColors.astraGold,
              tooltip: "Expand 3D Astra Stage",
              onPressed: widget.onToggleExpand,
            ),
          ],
        ),
      );
    }

    // Full 3D Interactive Stage
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withOpacity(0.7),
                  const Color(0xFF0F172A).withOpacity(0.7),
                ]
              : [
                  const Color(0xFFF0F9FF),
                  const Color(0xFFFAF5FF),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.astraSkyLight.withOpacity(isDark ? 0.35 : 0.45),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.astraPurpleCosmic.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Top Control Ribbon
            Positioned(
              top: 10,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A).withOpacity(0.8)
                          : Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getStateColor().withOpacity(0.6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: _getStateColor(), size: 7),
                        const SizedBox(width: 6),
                        Text(
                          _getStateTitle(),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: _getStateColor(),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Collapse button
                  GestureDetector(
                    onTap: widget.onToggleExpand,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : Colors.black.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_fullscreen_rounded, size: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Center Interactive 3D Astra Orb
            Center(
              child: MiaAstra3dOrb(
                size: 155,
                state: widget.state,
                interactive: true,
                onTap: () {
                  // Interactive touch pulse
                  widget.onSelectPrompt("✨ Tell me an uplifting Quranic reflection!");
                },
              ),
            ),

            // Revolving 3D Orbital Satellites
            AnimatedBuilder(
              animation: _satelliteController,
              builder: (context, _) {
                return Stack(
                  children: _prompts.map((satellite) {
                    final phase = (_satelliteController.value + satellite.speedOffset) % 1.0;
                    final angle = phase * 2 * math.pi;

                    // Elliptical 3D orbit around the center
                    final orbitX = math.cos(angle) * 118;
                    final orbitY = math.sin(angle) * 44 + 8; // Inclined plane
                    final z = math.sin(angle); // -1 (back) to +1 (front)

                    final normalizedZ = ((z + 1.0) / 2.0).clamp(0.0, 1.0);
                    final scale = 0.78 + (normalizedZ * 0.32);
                    final opacity = (0.45 + (normalizedZ * 0.55)).clamp(0.2, 1.0);

                    return Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(orbitX, orbitY),
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: GestureDetector(
                              onTap: () => widget.onSelectPrompt(satellite.prompt),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4.5,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [
                                            const Color(0xFF1E1B4B).withOpacity(0.92),
                                            const Color(0xFF0F172A).withOpacity(0.92),
                                          ]
                                        : [
                                            Colors.white.withOpacity(0.95),
                                            const Color(0xFFF1F5F9).withOpacity(0.95),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: satellite.color.withOpacity(0.65),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: satellite.color.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(satellite.icon, size: 12, color: satellite.color),
                                    const SizedBox(width: 5),
                                    Text(
                                      satellite.label,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // Bottom Audio Frequency Spectrum Bars
            Positioned(
              bottom: 8,
              child: _buildAudioVisualizerBars(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioVisualizerBars() {
    return AnimatedBuilder(
      animation: _satelliteController,
      builder: (context, _) {
        final isActive = widget.state == MiaOrbState.speaking || widget.state == MiaOrbState.listening;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(12, (index) {
            final wave = math.sin((_satelliteController.value * 8 * math.pi) + (index * 0.5)).abs();
            final height = isActive ? (4.0 + (wave * 14.0)) : 3.0;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3.0,
              height: height,
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? AppColors.astraSkyLight.withOpacity(0.7)
                    : AppColors.astraGoldLight.withOpacity(0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}

class _SatellitePrompt {
  final String label;
  final String prompt;
  final IconData icon;
  final Color color;
  final double speedOffset;

  _SatellitePrompt({
    required this.label,
    required this.prompt,
    required this.icon,
    required this.color,
    required this.speedOffset,
  });
}
