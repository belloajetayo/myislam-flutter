import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import 'islamic_ai_service.dart';
import 'myislam_ai_sheet.dart';
import 'widgets/3d/mia_astra_mini_orb.dart';

class MyIslamAiFloatingButton extends StatefulWidget {
  final Function(String route) onNavigate;

  const MyIslamAiFloatingButton({super.key, required this.onNavigate});

  @override
  State<MyIslamAiFloatingButton> createState() => _MyIslamAiFloatingButtonState();
}

class _MyIslamAiFloatingButtonState extends State<MyIslamAiFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _showTooltip = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Auto-hide the intro tooltip callout after 12 seconds
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted) setState(() => _showTooltip = false);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _openAiCompanion() {
    setState(() => _showTooltip = false);
    MyIslamAiSheet.show(context, onNavigate: widget.onNavigate);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isThinking = context.watch<IslamicAiService?>()?.isTyping ?? false;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Friendly Astra 3D Callout Bubble
        if (_showTooltip) ...[
          GestureDetector(
            onTap: _openAiCompanion,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF1E1B4B),
                          const Color(0xFF0F172A),
                        ]
                      : [
                          const Color(0xFFF0F9FF),
                          Colors.white,
                        ],
                ),
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomRight: const Radius.circular(2),
                ),
                border: Border.all(
                  color: AppColors.astraSkyLight.withOpacity(0.6),
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.astraPurple.withOpacity(isDark ? 0.4 : 0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("✨", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "MIA 3D Guide",
                            style: TextStyle(
                              color: AppColors.astraSky,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.astraGold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "ASTRA",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                color: AppColors.astraGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        "Tap for Quran, Duas & 3D Tour",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _showTooltip = false),
                    child: Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // 3D Astra Mini Orb with Volumetric Glow & Celestial Rotation
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.astraSkyLight.withOpacity(0.4),
                      blurRadius: 20 * _pulseAnimation.value,
                      spreadRadius: 2 * _pulseAnimation.value,
                    ),
                    BoxShadow(
                      color: AppColors.astraPurple.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _openAiCompanion,
              customBorder: const CircleBorder(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MiaAstraMiniOrb(
                    size: 58,
                    isThinking: isThinking,
                  ),
                  // Small golden "3D" badge at bottom-right
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        gradient: AppColors.astraTrilateralGradient,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white, width: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Text(
                        "3D",
                        style: TextStyle(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
