import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class Holographic3dCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double maxTilt;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? baseColor;
  final Border? border;
  final bool enableSheen;

  const Holographic3dCard({
    super.key,
    required this.child,
    this.onTap,
    this.maxTilt = 0.18, // In radians (~10 degrees max tilt)
    this.borderRadius,
    this.padding,
    this.baseColor,
    this.border,
    this.enableSheen = true,
  });

  @override
  State<Holographic3dCard> createState() => _Holographic3dCardState();
}

class _Holographic3dCardState extends State<Holographic3dCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _springController;
  late Animation<Offset> _springAnimation;

  Offset _tilt = Offset.zero; // x: yaw (rotateY), y: pitch (-rotateX)
  Offset _touchPosition = const Offset(0.5, 0.5); // Normalized 0..1
  bool _isHoveredOrPressed = false;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _springAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _springController, curve: Curves.elasticOut),
    )..addListener(() {
        setState(() => _tilt = _springAnimation.value);
      });
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final normX = (event.localPosition.dx / size.width).clamp(0.0, 1.0);
    final normY = (event.localPosition.dy / size.height).clamp(0.0, 1.0);

    setState(() {
      _touchPosition = Offset(normX, normY);
      // Tilt yaw rotates on Y axis, pitch rotates on X axis
      final yaw = (normX - 0.5) * widget.maxTilt * 2;
      final pitch = -(normY - 0.5) * widget.maxTilt * 2;
      _tilt = Offset(yaw, pitch);
      _isHoveredOrPressed = true;
    });
  }

  void _onPointerExit(PointerExitEvent event) {
    _resetTilt();
  }

  void _onPointerUp(PointerUpEvent event) {
    _resetTilt();
  }

  void _resetTilt() {
    _springAnimation = Tween<Offset>(begin: _tilt, end: Offset.zero).animate(
      CurvedAnimation(parent: _springController, curve: Curves.easeOutBack),
    );
    _springController.forward(from: 0);
    setState(() => _isHoveredOrPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = widget.borderRadius ?? BorderRadius.circular(20);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // 3D Perspective Matrix (Perspective foreshortening at setEntry(3, 2, 0.0014))
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0014)
          ..rotateY(_tilt.dx)
          ..rotateX(_tilt.dy);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHoveredOrPressed = true),
          onExit: _onPointerExit,
          onHover: (event) => _onPointerMove(event, size),
          child: Listener(
            onPointerDown: (event) => _onPointerMove(event, size),
            onPointerMove: (event) => _onPointerMove(event, size),
            onPointerUp: _onPointerUp,
            onPointerCancel: (_) => _resetTilt(),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Transform(
                transform: transform,
                alignment: FractionalOffset.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    boxShadow: [
                      BoxShadow(
                        color: _isHoveredOrPressed
                            ? AppColors.astraPurple.withOpacity(isDark ? 0.35 : 0.20)
                            : Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                        blurRadius: _isHoveredOrPressed ? 24 : 12,
                        offset: Offset(-_tilt.dx * 35, 6 - (_tilt.dy * 25)),
                      ),
                      if (_isHoveredOrPressed)
                        BoxShadow(
                          color: AppColors.astraSkyLight.withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 0),
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: radius,
                    child: Stack(
                      children: [
                        // Card Base Layer
                        Container(
                          padding: widget.padding,
                          decoration: BoxDecoration(
                            color: widget.baseColor ??
                                (isDark ? AppColors.darkCardBg : Colors.white),
                            borderRadius: radius,
                            border: widget.border ??
                                Border.all(
                                  color: _isHoveredOrPressed
                                      ? AppColors.astraGoldLight.withOpacity(0.7)
                                      : (isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder),
                                  width: _isHoveredOrPressed ? 1.5 : 1.0,
                                ),
                          ),
                          child: widget.child,
                        ),

                        // Holographic Specular Glare Layer
                        if (widget.enableSheen && _isHoveredOrPressed)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: radius,
                                  gradient: RadialGradient(
                                    center: Alignment(
                                      (_touchPosition.dx * 2) - 1.0,
                                      (_touchPosition.dy * 2) - 1.0,
                                    ),
                                    radius: 0.9,
                                    colors: [
                                      Colors.white.withOpacity(0.22),
                                      AppColors.astraSkyLight.withOpacity(0.12),
                                      AppColors.astraGoldLight.withOpacity(0.08),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.35, 0.65, 1.0],
                                  ),
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
          ),
        );
      },
    );
  }
}
