import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../core/utils/geo_utils.dart';

class QiblahScreen extends StatefulWidget {
  final VoidCallback onBack;

  const QiblahScreen({super.key, required this.onBack});

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

class _QiblahScreenState extends State<QiblahScreen> with SingleTickerProviderStateMixin {
  // Lagos reference coordinates (can be updated with GPS)
  final double _userLat = 6.5244;
  final double _userLng = 3.3792;
  double _deviceHeading = 45.0; // Current heading in degrees
  late double _qiblaBearing;
  late double _distanceToKaabaKm;

  @override
  void initState() {
    super.initState();
    _qiblaBearing = GeoUtils.calculateQiblaBearing(_userLat, _userLng);
    _distanceToKaabaKm = GeoUtils.calculateDistanceKm(_userLat, _userLng, GeoUtils.kaabaLat, GeoUtils.kaabaLng);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final diff = ((_qiblaBearing - _deviceHeading + 360) % 360).round();
    final isFacing = diff < 5 || diff > 355;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          // Header Bar
          Row(
            children: [
              AnimatedBackButton(onPressed: widget.onBack),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Qiblah Compass",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.islamicGold,
                      ),
                    ),
                    Text(
                      "Find direction to the Holy Kaaba",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Compass Dial Section
          Center(
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glowing ring
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isFacing
                          ? const RadialGradient(colors: [Color(0x3310B981), Colors.transparent])
                          : RadialGradient(colors: [AppColors.islamicGold.withOpacity(0.15), Colors.transparent]),
                    ),
                  ),

                  // Rotating dial background
                  Transform.rotate(
                    angle: -_deviceHeading * (math.pi / 180.0),
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF131131) : Colors.white,
                        border: Border.all(
                          color: isFacing ? const Color(0xFF10B981) : AppColors.islamicGold.withOpacity(0.4),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isFacing ? const Color(0x4410B981) : Colors.black.withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // North marker
                          Positioned(
                            top: 10,
                            child: Column(
                              children: [
                                const Text(
                                  "N",
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.red),
                                ),
                                Container(width: 2, height: 8, color: Colors.red),
                              ],
                            ),
                          ),
                          const Positioned(right: 14, child: Text("E", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                          const Positioned(bottom: 12, child: Text("S", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                          const Positioned(left: 14, child: Text("W", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                        ],
                      ),
                    ),
                  ),

                  // Kaaba pointer needle pointing to _qiblaBearing
                  Transform.rotate(
                    angle: (_qiblaBearing - _deviceHeading) * (math.pi / 180.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFacing ? const Color(0xFF10B981) : AppColors.islamicGold,
                            boxShadow: [
                              BoxShadow(
                                color: (isFacing ? const Color(0xFF10B981) : AppColors.islamicGold).withOpacity(0.5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(height: 70), // distance to center
                      ],
                    ),
                  ),

                  // Center Kaaba Emblem
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF0F0C29) : const Color(0xFFEEF2FF),
                      border: Border.all(color: AppColors.islamicGold, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Text("🕋", style: TextStyle(fontSize: 22)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Alignment status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: isFacing
                  ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)])
                  : (isDark ? const LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF172554)]) : AppColors.heroPrayerGradient),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFacing ? "Facing Kaaba! 🕋" : "Turn ${diff > 180 ? 360 - diff : diff}° ${diff > 180 ? 'Left' : 'Right'}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      "Qiblah is at ${_qiblaBearing.round()}° from North",
                      style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    "${_deviceHeading.round()}°",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Distance Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.straighten_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Distance to Holy Kaaba", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        "${_distanceToKaabaKm.toStringAsFixed(0)} km",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
