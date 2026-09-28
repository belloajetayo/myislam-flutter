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
  final double _userLat = 6.5244;
  final double _userLng = 3.3792;
  final double _deviceHeading = 45.0; // Simulated heading
  late double _qiblaBearing;
  late double _distanceToKaabaKm;
  bool _calibrating = false;

  static const List<Map<String, dynamic>> _mockMosques = [
    {
      "name": "Central Mosque",
      "address": "46 Imam Ligali St, Marina",
      "distance": "850m",
      "distanceNum": 0.85,
    },
    {
      "name": "Al-Noor Islamic Center",
      "address": "12 Broad Street, Lagos Island",
      "distance": "1.4km",
      "distanceNum": 1.4,
    },
    {
      "name": "Masjid As-Salam",
      "address": "28 Campbell St, Victoria Island",
      "distance": "2.2km",
      "distanceNum": 2.2,
    },
    {
      "name": "Tawhid Community Mosque",
      "address": "5 Adeola Odeku St, VI",
      "distance": "3.5km",
      "distanceNum": 3.5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _qiblaBearing = GeoUtils.calculateQiblaBearing(_userLat, _userLng);
    _distanceToKaabaKm = GeoUtils.calculateDistanceKm(_userLat, _userLng, GeoUtils.kaabaLat, GeoUtils.kaabaLng);
  }

  void _showGuidanceDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.primaryGold),
              SizedBox(width: 8),
              Text(
                "Finding Qiblah Guidance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Precision Tips:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryGold)),
                      SizedBox(height: 4),
                      Text("• Hold phone flat (parallel to the ground)", style: TextStyle(fontSize: 12)),
                      Text("• Avoid metal cases or magnetic mounts", style: TextStyle(fontSize: 12)),
                      Text("• Move phone in figure-8 (∞) to calibrate", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text("From the Sunnah:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                const Text(
                  "\"The Prophet ﷺ said: 'What is between the East and West is Qiblah.'\"\n— Sunan Ibn Majah",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
                const SizedBox(height: 14),
                const Text("How to use:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                const Text(
                  "1. Hold your phone flat and level\n2. The compass needle with the Kaaba points toward Makkah\n3. Rotate your body until the needle points straight up\n4. You are now facing the Qiblah!",
                  style: TextStyle(fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Got it", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.islamicIndigo)),
            ),
          ],
        );
      },
    );
  }

  void _showNearbyMosques() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.65,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.mosque_rounded, color: Color(0xFF10B981), size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Mosques Near You",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text("Find nearby places of congregation and prayer", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _mockMosques.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final m = _mockMosques[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF0D9488)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m["name"] as String,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  m["address"] as String,
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              m["distance"] as String,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _calibrate() {
    setState(() => _calibrating = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _calibrating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Compass calibrated for high precision! ✨"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Qiblah Direction",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.islamicGold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: _showGuidanceDialog,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(isDark ? 0.08 : 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline_rounded, size: 16, color: isDark ? Colors.white70 : Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: AppColors.primaryGold),
                        SizedBox(width: 3),
                        Text(
                          "Accurate GPS Location",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sun Direction Indicators (Sunrise 90° East & Sunset 270° West from Qiblah.tsx)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wb_sunny_rounded, color: Color(0xFFF59E0B), size: 18),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sunrise", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text("East (90°)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEA580C).withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wb_twilight_rounded, color: Color(0xFFEA580C), size: 18),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sunset", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text("West (270°)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEA580C))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Compass Dial Section
          Center(
            child: SizedBox(
              width: 290,
              height: 290,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glowing ring
                  Container(
                    width: 290,
                    height: 290,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isFacing
                          ? const RadialGradient(colors: [Color(0x3310B981), Colors.transparent])
                          : RadialGradient(colors: [AppColors.islamicGold.withOpacity(0.15), Colors.transparent]),
                    ),
                  ),

                  // Outer Ring with Degree Markings & Cardinals
                  Transform.rotate(
                    angle: -_deviceHeading * (math.pi / 180.0),
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF131131) : Colors.white,
                        border: Border.all(
                          color: isFacing ? const Color(0xFF10B981) : AppColors.islamicGold.withOpacity(0.4),
                          width: 3.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isFacing ? const Color(0x4410B981) : Colors.black.withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Stack(
                        alignment: Alignment.center,
                        children: [
                          // North marker
                          Positioned(
                            top: 8,
                            child: Text(
                              "N",
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF10B981)),
                            ),
                          ),
                          Positioned(right: 12, child: Text("E", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey))),
                          Positioned(bottom: 8, child: Text("S", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey))),
                          Positioned(left: 12, child: Text("W", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey))),
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
                        // Needle tip pointing to Kaaba
                        Container(
                          padding: const EdgeInsets.all(7),
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
                          child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 76),
                      ],
                    ),
                  ),

                  // Center Kaaba Emblem
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF0F0C29) : const Color(0xFFEEF2FF),
                      border: Border.all(color: AppColors.islamicGold, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Text("🕋", style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 3-Column Direction Info Card (Heading | Qiblah | GPS from Qiblah.tsx)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("Your Heading", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 3),
                        Text("${_deviceHeading.round()}°", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(width: 1, height: 32, color: Colors.grey.withOpacity(0.2)),
                    Column(
                      children: [
                        const Text("Qiblah", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 3),
                        Text(
                          "${_qiblaBearing.round()}°",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1, height: 32, color: Colors.grey.withOpacity(0.2)),
                    const Column(
                      children: [
                        Text("GPS", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        SizedBox(height: 3),
                        Text("±5m", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                const SizedBox(height: 8),
                Text(
                  isFacing ? "Aligned with Kaaba! 🕋" : "Turn ${diff > 180 ? 360 - diff : diff}° ${diff > 180 ? 'Left' : 'Right'} to align",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isFacing ? const Color(0xFF10B981) : (isDark ? Colors.white70 : Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons: Calibrate & Mosque Near Me (from Qiblah.tsx)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _calibrating ? null : _calibrate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFF7C3AED)]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _calibrating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.sync_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          _calibrating ? "Calibrating..." : "Calibrate",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: _showNearbyMosques,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF0D9488)]),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mosque_rounded, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Mosque Near Me",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Distance Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
                      const Text("Distance to Holy Kaaba", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(
                        "${_distanceToKaabaKm.toStringAsFixed(0)} km",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
