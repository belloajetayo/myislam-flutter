import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class AnimatedBackButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? iconColor;
  final double size;

  const AnimatedBackButton({
    super.key,
    required this.onPressed,
    this.tooltip,
    this.iconColor,
    this.size = 42.0,
  });

  @override
  State<AnimatedBackButton> createState() => _AnimatedBackButtonState();
}

class _AnimatedBackButtonState extends State<AnimatedBackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    _controller.reverse();
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget button = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: widget.size,
                height: widget.size,
                transform: Matrix4.translationValues(
                  _isHovered ? -2.5 : 0.0,
                  0.0,
                  0.0,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? (_isHovered
                          ? Colors.white.withOpacity(0.14)
                          : Colors.white.withOpacity(0.08))
                      : (_isHovered ? const Color(0xFFF1F5F9) : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovered
                        ? AppColors.islamicGold.withOpacity(0.6)
                        : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                    width: _isHovered ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? AppColors.islamicGold.withOpacity(0.25)
                          : Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: _isHovered ? 12 : 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: widget.size * 0.48,
                  color: widget.iconColor ??
                      (_isHovered
                          ? AppColors.islamicGold
                          : (isDark ? Colors.white : const Color(0xFF1E293B))),
                ),
              ),
            );
          },
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    return button;
  }
}
