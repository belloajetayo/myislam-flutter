import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MiaAstraMiniOrb extends StatefulWidget {
  final double size;
  final bool isThinking;

  const MiaAstraMiniOrb({
    super.key,
    this.size = 52,
    this.isThinking = false,
  });

  @override
  State<MiaAstraMiniOrb> createState() => _MiaAstraMiniOrbState();
}

class _MiaAstraMiniOrbState extends State<MiaAstraMiniOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _MiniOrbPainter(
              progress: _controller.value,
              isThinking: widget.isThinking,
            ),
          ),
        );
      },
    );
  }
}

class _MiniOrbPainter extends CustomPainter {
  final double progress;
  final bool isThinking;

  _MiniOrbPainter({required this.progress, required this.isThinking});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final coreRadius = size.width * 0.32;

    // 1. Soft atmospheric bloom (Sky Blue + Gold)
    final bloomRadius = size.width * 0.48;
    canvas.drawCircle(
      center,
      bloomRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.astraSkyLight.withOpacity(0.45),
            AppColors.astraGoldLight.withOpacity(0.25),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: bloomRadius)),
    );

    // 2. 3D Astrolabe Ring (Background half Z < 0)
    _drawRing(canvas, center, coreRadius * 1.45, isBackground: true);

    // 3. Volumetric Core (Sky Blue to Shining Gold to Royal Purple)
    final coreGradient = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      radius: 1.05,
      colors: const [
        Color(0xFFFFFBEB), // Specular highlight
        Color(0xFF7DD3FC), // Friendly Sky Blue
        Color(0xFF0EA5E9), // Sky Blue
        Color(0xFFF59E0B), // Warm Gold
        Color(0xFF8B5CF6), // Royal Purple
        Color(0xFF4C1D95), // Deep Cosmic Purple
      ],
      stops: const [0.0, 0.25, 0.50, 0.72, 0.88, 1.0],
    );

    // Drop shadow
    canvas.drawCircle(
      center + const Offset(0, 3),
      coreRadius,
      Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Core sphere
    canvas.drawCircle(
      center,
      coreRadius,
      Paint()
        ..shader = coreGradient.createShader(Rect.fromCircle(center: center, radius: coreRadius)),
    );

    // Glassy rim highlight
    canvas.drawCircle(
      center,
      coreRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = Colors.white.withOpacity(0.75),
    );

    // 4. Subtle inner Islamic star sparkle
    final starRadius = coreRadius * 0.42;
    final starAngle = progress * 2 * math.pi * (isThinking ? 2.0 : 0.6);
    final starPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withOpacity(0.65);

    final path = Path();
    for (int i = 0; i < 4; i++) {
      final a = starAngle + (i * math.pi / 2);
      final p = Offset(center.dx + starRadius * math.cos(a), center.dy + starRadius * math.sin(a));
      if (i == 0) path.moveTo(p.dx, p.dy); else path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, starPaint);

    // 5. 3D Astrolabe Ring (Foreground half Z >= 0)
    _drawRing(canvas, center, coreRadius * 1.45, isBackground: false);
  }

  void _drawRing(Canvas canvas, Offset center, double ringRadius, {required bool isBackground}) {
    const segments = 36;
    final step = 2 * math.pi / segments;
    final rot = progress * 2 * math.pi;

    for (int i = 0; i < segments; i++) {
      final a1 = rot + (i * step);
      final a2 = rot + ((i + 1) * step);

      // Project onto 3D inclined plane (35 degrees pitch)
      const tilt = 0.55;
      final x1 = ringRadius * math.cos(a1);
      final y1 = ringRadius * math.sin(a1) * math.cos(tilt);
      final z1 = ringRadius * math.sin(a1) * math.sin(tilt);

      final x2 = ringRadius * math.cos(a2);
      final y2 = ringRadius * math.sin(a2) * math.cos(tilt);
      final z2 = ringRadius * math.sin(a2) * math.sin(tilt);

      final avgZ = (z1 + z2) / 2;
      if (isBackground ? avgZ >= 0 : avgZ < 0) continue;

      final normZ = ((avgZ / ringRadius) + 1.0) / 2.0;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6 * (0.6 + normZ * 0.6)
        ..color = Color.lerp(
          AppColors.astraSkyLight,
          AppColors.astraGoldLight,
          (i / segments),
        )!.withOpacity(0.3 + (normZ * 0.7));

      canvas.drawLine(center + Offset(x1, y1), center + Offset(x2, y2), paint);

      // Satellite beacon
      if (i == 0 && !isBackground) {
        canvas.drawCircle(
          center + Offset(x1, y1),
          2.6,
          Paint()..color = Colors.white,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MiniOrbPainter oldDelegate) => true;
}
