import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum MiaOrbState {
  idle,
  listening,
  thinking,
  speaking,
}

class MiaAstra3dOrb extends StatefulWidget {
  final double size;
  final MiaOrbState state;
  final bool interactive;
  final VoidCallback? onTap;

  const MiaAstra3dOrb({
    super.key,
    this.size = 180,
    this.state = MiaOrbState.idle,
    this.interactive = true,
    this.onTap,
  });

  @override
  State<MiaAstra3dOrb> createState() => _MiaAstra3dOrbState();
}

class _MiaAstra3dOrbState extends State<MiaAstra3dOrb>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  // Interactive 3D drag & momentum physics
  double _pitch = 0.2; // X-axis tilt
  double _yaw = 0.3; // Y-axis tilt
  double _dragStartX = 0.0;
  double _dragStartY = 0.0;
  bool _isDragging = false;

  // Particle cloud data (fixed seed for deterministic beauty)
  late List<_Astra3dParticle> _particles;

  @override
  void initState() {
    super.initState();

    // Constant ambient 3D orbit rotation (12s loop)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Gentle breathing harmonic pulse (3s loop)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    // Dynamic wave ripples (listening / speaking / thinking)
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    // Initialize 48 3D spherical stardust particles
    final rand = math.Random(114); // 114 Surahs in Quran
    _particles = List.generate(48, (index) {
      final theta = rand.nextDouble() * 2 * math.pi;
      final phi = math.acos(2 * rand.nextDouble() - 1);
      final radius = 0.85 + rand.nextDouble() * 0.45;
      final speed = 0.4 + rand.nextDouble() * 0.8;
      final size = 1.6 + rand.nextDouble() * 2.6;
      final colorType = index % 3; // 0: Sky Blue, 1: Gold, 2: Purple
      return _Astra3dParticle(
        theta: theta,
        phi: phi,
        radius: radius,
        speed: speed,
        size: size,
        colorType: colorType,
      );
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.interactive) return;
    _isDragging = true;
    _dragStartX = details.localPosition.dx;
    _dragStartY = details.localPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.interactive) return;
    setState(() {
      final dx = details.localPosition.dx - _dragStartX;
      final dy = details.localPosition.dy - _dragStartY;
      _yaw += dx * 0.012;
      _pitch = (_pitch - dy * 0.012).clamp(-1.2, 1.2);
      _dragStartX = details.localPosition.dx;
      _dragStartY = details.localPosition.dy;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.interactive) return;
    _isDragging = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _pulseController,
          _waveController,
        ]),
        builder: (context, _) {
          // Slowly relax tilt back towards center when not dragging
          if (!_isDragging) {
            _pitch += (0.15 - _pitch) * 0.02;
            _yaw += 0.005; // Gentle continuous auto-spin
          }

          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _Astra3dOrbPainter(
                pitch: _pitch,
                yaw: _yaw,
                rotationProgress: _rotationController.value,
                pulseProgress: _pulseController.value,
                waveProgress: _waveController.value,
                state: widget.state,
                particles: _particles,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Astra3dParticle {
  double theta;
  double phi;
  final double radius;
  final double speed;
  final double size;
  final int colorType;

  _Astra3dParticle({
    required this.theta,
    required this.phi,
    required this.radius,
    required this.speed,
    required this.size,
    required this.colorType,
  });
}

class _Astra3dOrbPainter extends CustomPainter {
  final double pitch;
  final double yaw;
  final double rotationProgress;
  final double pulseProgress;
  final double waveProgress;
  final MiaOrbState state;
  final List<_Astra3dParticle> particles;

  _Astra3dOrbPainter({
    required this.pitch,
    required this.yaw,
    required this.rotationProgress,
    required this.pulseProgress,
    required this.waveProgress,
    required this.state,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = (size.width / 2) * 0.52;

    // State dynamic modifiers
    double pulseScale = 1.0;
    double ringSpeedMult = 1.0;
    switch (state) {
      case MiaOrbState.idle:
        pulseScale = 1.0 + (pulseProgress * 0.06);
        ringSpeedMult = 1.0;
        break;
      case MiaOrbState.listening:
        pulseScale = 1.08 + (math.sin(waveProgress * 2 * math.pi) * 0.08);
        ringSpeedMult = 2.0;
        break;
      case MiaOrbState.thinking:
        pulseScale = 1.02 + (math.sin(waveProgress * 4 * math.pi) * 0.05);
        ringSpeedMult = 3.2;
        break;
      case MiaOrbState.speaking:
        pulseScale = 1.12 + (math.cos(waveProgress * 3 * math.pi) * 0.10);
        ringSpeedMult = 2.4;
        break;
    }

    final coreRadius = baseRadius * pulseScale;

    // 1. Exterior Celestial Atmosphere Glow (Sky Blue, Gold, Purple)
    _paintAtmosphere(canvas, center, coreRadius);

    // 2. Sonic wave ripples in Listening or Speaking mode
    if (state == MiaOrbState.listening || state == MiaOrbState.speaking) {
      _paintSonicRipples(canvas, center, coreRadius);
    }

    // 3. Render 3D Background Objects (Z < 0: behind core)
    _paintParticles(canvas, center, coreRadius, isBackground: true);
    _paintOrbitalRings(canvas, center, coreRadius, ringSpeedMult, isBackground: true);

    // 4. Render Volumetric 3D Orb Core (Sky Blue, Shining Gold & Deep Purple)
    _paintVolumetricCore(canvas, center, coreRadius);

    // 5. Render Friendly Light Expressions & Islamic Sacred Geometry Flare
    _paintFriendlyExpressions(canvas, center, coreRadius);

    // 6. Render 3D Foreground Objects (Z > 0: in front of core)
    _paintOrbitalRings(canvas, center, coreRadius, ringSpeedMult, isBackground: false);
    _paintParticles(canvas, center, coreRadius, isBackground: false);

    // 7. Specular Flare Highlight (Simulates moving light reflection on glassy sphere)
    _paintSpecularHighlight(canvas, center, coreRadius);
  }

  void _paintAtmosphere(Canvas canvas, Offset center, double radius) {
    final atmosphereRadius = radius * 2.1;
    final atmospherePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.astraSkyLight.withOpacity(0.35),
          AppColors.astraGold.withOpacity(0.22),
          AppColors.astraPurple.withOpacity(0.18),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 0.72, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: atmosphereRadius));

    canvas.drawCircle(center, atmosphereRadius, atmospherePaint);
  }

  void _paintSonicRipples(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 3; i++) {
      final wavePhase = (waveProgress + (i * 0.33)) % 1.0;
      final waveRadius = radius * (1.15 + (wavePhase * 0.85));
      final opacity = (1.0 - wavePhase).clamp(0.0, 1.0) * 0.55;

      final wavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * (1.0 - wavePhase * 0.5)
        ..shader = LinearGradient(
          colors: [
            AppColors.astraSkyLight.withOpacity(opacity),
            AppColors.astraGoldLight.withOpacity(opacity),
            AppColors.astraPurple.withOpacity(opacity),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: waveRadius));

      canvas.drawCircle(center, waveRadius, wavePaint);
    }
  }

  void _paintVolumetricCore(Canvas canvas, Offset center, double radius) {
    // Dynamic light direction based on pitch & yaw
    final lightOffset = Offset(
      center.dx - (radius * 0.38) + (yaw * 6.0).clamp(-12.0, 12.0),
      center.dy - (radius * 0.38) + (pitch * 6.0).clamp(-12.0, 12.0),
    );

    // Multi-stop volumetric 3D spherical gradient
    final coreGradient = RadialGradient(
      center: Alignment(
        (lightOffset.dx - center.dx) / radius,
        (lightOffset.dy - center.dy) / radius,
      ),
      radius: 1.15,
      colors: [
        AppColors.astraGoldShine, // 0.0 Specular Gold Hotspot
        AppColors.astraSkyLight, // 0.22 Friendly Sky Blue
        AppColors.astraSky, // 0.45 Radiant Sky Blue
        AppColors.astraGold, // 0.65 Warm Shining Gold
        AppColors.astraPurple, // 0.82 Royal Purple
        AppColors.astraPurpleCosmic, // 1.0 Deep Indigo Shadow
      ],
      stops: const [0.0, 0.22, 0.45, 0.65, 0.82, 1.0],
    );

    final corePaint = Paint()
      ..shader = coreGradient.createShader(Rect.fromCircle(center: center, radius: radius));

    // Outer core shadow for floating depth
    canvas.drawCircle(
      center + const Offset(0, 8),
      radius,
      Paint()
        ..color = Colors.black.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );

    // Render sphere
    canvas.drawCircle(center, radius, corePaint);

    // Inner rim glow for translucent glassmorphic look
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.85),
          AppColors.astraGoldLight.withOpacity(0.6),
          AppColors.astraSkyLight.withOpacity(0.4),
          Colors.white.withOpacity(0.1),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, rimPaint);
  }

  void _paintFriendlyExpressions(Canvas canvas, Offset center, double radius) {
    // 1. Subtle glowing 8-pointed star rosette (Islamic sacred geometry) at core center
    final starSize = radius * 0.45;
    final starAngle = rotationProgress * 2 * math.pi * (state == MiaOrbState.thinking ? 2.5 : 0.8);
    final starPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white.withOpacity(0.32 + (pulseProgress * 0.25));

    final path1 = Path();
    final path2 = Path();

    // Two overlapping squares rotated 45 degrees
    for (int i = 0; i < 4; i++) {
      final a1 = starAngle + (i * math.pi / 2);
      final a2 = starAngle + (i * math.pi / 2) + (math.pi / 4);
      final p1 = Offset(center.dx + starSize * math.cos(a1), center.dy + starSize * math.sin(a1));
      final p2 = Offset(center.dx + starSize * math.cos(a2), center.dy + starSize * math.sin(a2));
      if (i == 0) {
        path1.moveTo(p1.dx, p1.dy);
        path2.moveTo(p2.dx, p2.dy);
      } else {
        path1.lineTo(p1.dx, p1.dy);
        path2.lineTo(p2.dx, p2.dy);
      }
    }
    path1.close();
    path2.close();
    canvas.drawPath(path1, starPaint);
    canvas.drawPath(path2, starPaint);

    // 2. Friendly luminous crescent smile arc at the center
    final smileRect = Rect.fromCircle(center: center + Offset(0, radius * 0.08), radius: radius * 0.22);
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4
      ..shader = const LinearGradient(
        colors: [AppColors.astraSkyLight, AppColors.astraGoldLight],
      ).createShader(smileRect);

    canvas.drawArc(smileRect, 0.25 * math.pi, 0.5 * math.pi, false, smilePaint);
  }

  void _paintOrbitalRings(
    Canvas canvas,
    Offset center,
    double coreRadius,
    double speedMult,
    {required bool isBackground}
  ) {
    // 3 Unique 3D Rings at distinct astronomical inclinations
    final rings = [
      _RingSpec(
        inclinationX: 0.55 + pitch * 0.4,
        inclinationY: 0.15 + yaw * 0.5,
        tiltAngle: 0.45,
        radius: coreRadius * 1.48,
        speed: 1.0 * speedMult,
        strokeWidth: 2.2,
        colorStart: AppColors.astraSkyLight,
        colorEnd: AppColors.astraGold,
      ),
      _RingSpec(
        inclinationX: -0.40 - pitch * 0.3,
        inclinationY: 0.85 + yaw * 0.6,
        tiltAngle: -0.80,
        radius: coreRadius * 1.72,
        speed: -0.8 * speedMult,
        strokeWidth: 1.8,
        colorStart: AppColors.astraGoldLight,
        colorEnd: AppColors.astraPurple,
      ),
      _RingSpec(
        inclinationX: 0.90 + pitch * 0.5,
        inclinationY: -0.35 + yaw * 0.4,
        tiltAngle: 1.30,
        radius: coreRadius * 1.95,
        speed: 0.6 * speedMult,
        strokeWidth: 1.4,
        colorStart: AppColors.astraSkyCyan,
        colorEnd: AppColors.astraSkySoft,
      ),
    ];

    for (final ring in rings) {
      _paintSingle3dRing(canvas, center, ring, isBackground);
    }
  }

  void _paintSingle3dRing(Canvas canvas, Offset center, _RingSpec ring, bool isBackground) {
    const segments = 72;
    final step = 2 * math.pi / segments;
    final currentRotation = rotationProgress * 2 * math.pi * ring.speed;

    for (int i = 0; i < segments; i++) {
      final a1 = currentRotation + (i * step);
      final a2 = currentRotation + ((i + 1) * step);

      // 3D coordinates on flat ring plane
      final x1 = ring.radius * math.cos(a1);
      final y1 = ring.radius * math.sin(a1);
      final x2 = ring.radius * math.cos(a2);
      final y2 = ring.radius * math.sin(a2);

      // 3D rotation projection using Euler angles
      final p1 = _project3d(x1, y1, 0, ring.inclinationX, ring.inclinationY, ring.tiltAngle);
      final p2 = _project3d(x2, y2, 0, ring.inclinationX, ring.inclinationY, ring.tiltAngle);

      final avgZ = (p1.z + p2.z) / 2.0;

      // Z-buffering: Background ring segments have Z < 0, Foreground segments have Z >= 0
      final matchesDepth = isBackground ? avgZ < 0 : avgZ >= 0;
      if (!matchesDepth) continue;

      final normalizedDepth = ((avgZ / ring.radius) + 1.0) / 2.0; // 0.0 (far) to 1.0 (near)
      final opacity = (0.25 + (normalizedDepth * 0.75)).clamp(0.1, 1.0);

      final segPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring.strokeWidth * (0.6 + normalizedDepth * 0.7)
        ..color = Color.lerp(ring.colorStart, ring.colorEnd, (i / segments))!.withOpacity(opacity);

      canvas.drawLine(
        center + Offset(p1.x, p1.y),
        center + Offset(p2.x, p2.y),
        segPaint,
      );

      // Orbiting Satellite Beacon on the ring
      if (i == 0 && matchesDepth) {
        final beaconPaint = Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);

        canvas.drawCircle(center + Offset(p1.x, p1.y), 3.5 * (0.8 + normalizedDepth * 0.6), beaconPaint);
      }
    }
  }

  void _paintParticles(
    Canvas canvas,
    Offset center,
    double coreRadius,
    {required bool isBackground}
  ) {
    final particleRadius = coreRadius * 1.55;

    for (final p in particles) {
      // Dynamic orbital motion around the sphere
      final currentTheta = p.theta + (rotationProgress * 2 * math.pi * p.speed);
      final r = particleRadius * p.radius;

      // Spherical to 3D Cartesian coordinates
      final x = r * math.sin(p.phi) * math.cos(currentTheta);
      final y = r * math.sin(p.phi) * math.sin(currentTheta);
      final z = r * math.cos(p.phi);

      // Apply pitch & yaw 3D transformations
      final pt = _project3d(x, y, z, pitch, yaw, 0.2);

      final matchesDepth = isBackground ? pt.z < 0 : pt.z >= 0;
      if (!matchesDepth) continue;

      final normalizedZ = ((pt.z / r) + 1.0) / 2.0; // 0.0 to 1.0
      final opacity = (0.25 + (normalizedZ * 0.75)).clamp(0.1, 1.0);
      final drawSize = p.size * (0.5 + normalizedZ * 0.8);

      Color pColor;
      if (p.colorType == 0) {
        pColor = AppColors.astraSkyLight;
      } else if (p.colorType == 1) {
        pColor = AppColors.astraGoldLight;
      } else {
        pColor = AppColors.astraPurple;
      }

      final pPaint = Paint()
        ..color = pColor.withOpacity(opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, isBackground ? 1.0 : 2.5);

      canvas.drawCircle(center + Offset(pt.x, pt.y), drawSize, pPaint);
    }
  }

  void _paintSpecularHighlight(Canvas canvas, Offset center, double radius) {
    // Glancing glassy shine on top-left of sphere
    final specularOffset = Offset(
      center.dx - (radius * 0.38) + (yaw * 4.0),
      center.dy - (radius * 0.38) + (pitch * 4.0),
    );

    final specularPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.75),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: specularOffset, radius: radius * 0.36));

    canvas.drawCircle(specularOffset, radius * 0.36, specularPaint);
  }

  _Point3d _project3d(double x, double y, double z, double rx, double ry, double rz) {
    // Rotation around X axis
    double y1 = y * math.cos(rx) - z * math.sin(rx);
    double z1 = y * math.sin(rx) + z * math.cos(rx);

    // Rotation around Y axis
    double x2 = x * math.cos(ry) + z1 * math.sin(ry);
    double z2 = -x * math.sin(ry) + z1 * math.cos(ry);

    // Rotation around Z axis
    double x3 = x2 * math.cos(rz) - y1 * math.sin(rz);
    double y3 = x2 * math.sin(rz) + y1 * math.cos(rz);

    // Perspective projection with focal distance
    const focalDistance = 420.0;
    final scale = focalDistance / (focalDistance + z2);

    return _Point3d(x3 * scale, y3 * scale, z2);
  }

  @override
  bool shouldRepaint(covariant _Astra3dOrbPainter oldDelegate) => true;
}

class _RingSpec {
  final double inclinationX;
  final double inclinationY;
  final double tiltAngle;
  final double radius;
  final double speed;
  final double strokeWidth;
  final Color colorStart;
  final Color colorEnd;

  _RingSpec({
    required this.inclinationX,
    required this.inclinationY,
    required this.tiltAngle,
    required this.radius,
    required this.speed,
    required this.strokeWidth,
    required this.colorStart,
    required this.colorEnd,
  });
}

class _Point3d {
  final double x;
  final double y;
  final double z;

  _Point3d(this.x, this.y, this.z);
}
