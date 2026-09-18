import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable Shining Purple-Gold Brand Title (from myislam2.vercel.app)
class ShiningBrandTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;

  const ShiningBrandTitle({
    super.key,
    this.text = "MyIslam",
    this.fontSize = 24,
    this.fontWeight = FontWeight.w900,
    this.letterSpacing = -0.5,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.purpleGoldShiningGradient.createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
