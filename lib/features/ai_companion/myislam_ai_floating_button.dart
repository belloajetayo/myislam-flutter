import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'myislam_ai_sheet.dart';

class MyIslamAiFloatingButton extends StatefulWidget {
  final Function(String route) onNavigate;

  const MyIslamAiFloatingButton({super.key, required this.onNavigate});

  @override
  State<MyIslamAiFloatingButton> createState() => _MyIslamAiFloatingButtonState();
}

class _MyIslamAiFloatingButtonState extends State<MyIslamAiFloatingButton> with SingleTickerProviderStateMixin {
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

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Auto-hide the intro tooltip callout after 12 seconds so it doesn't get in the way
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Optional Welcome Callout Bubble
        if (_showTooltip) ...[
          GestureDetector(
            onTap: _openAiCompanion,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF065F46)],
                ),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: const Radius.circular(2),
                ),
                border: Border.all(color: AppColors.goldWarm.withOpacity(0.6), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("✨", style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "MyIslam AI Guide",
                        style: TextStyle(
                          color: AppColors.goldLight,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Tap for App Tour & Quran help",
                        style: TextStyle(color: Colors.white70, fontSize: 9.5),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => _showTooltip = false),
                    child: const Icon(Icons.close_rounded, size: 14, color: Colors.white60),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Floating Action Orb with Breathing Glow
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
                      color: AppColors.goldWarm.withOpacity(0.4),
                      blurRadius: 16 * _pulseAnimation.value,
                      spreadRadius: 2 * _pulseAnimation.value,
                    ),
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withOpacity(0.3),
                      blurRadius: 10,
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
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFBBF24), // Vibrant gold
                      Color(0xFFD97706), // Royal amber
                      Color(0xFF047857), // Emerald
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.85), width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ornate center icon
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    // Small "AI" badge at bottom
                    Positioned(
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF064E3B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.goldWarm, width: 0.8),
                        ),
                        child: const Text(
                          "AI",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: AppColors.goldLight,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
