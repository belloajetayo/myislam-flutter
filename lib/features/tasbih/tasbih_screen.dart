import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';

class DhikrPreset {
  final String arabic;
  final String transliteration;
  final String meaning;
  final int defaultTarget;

  const DhikrPreset({
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    this.defaultTarget = 33,
  });
}

class TasbihScreen extends StatefulWidget {
  final VoidCallback onBack;

  const TasbihScreen({super.key, required this.onBack});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _totalCount = 0;
  int _laps = 0;
  int _selectedTarget = 33;
  int _selectedDhikrIndex = 0;
  bool _hapticsEnabled = true;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  static const List<DhikrPreset> _dhikrPresets = [
    DhikrPreset(
      arabic: "سُبْحَانَ ٱللَّهِ",
      transliteration: "SubhanAllah",
      meaning: "Glory be to Allah",
      defaultTarget: 33,
    ),
    DhikrPreset(
      arabic: "ٱلْحَمْدُ لِلَّهِ",
      transliteration: "Alhamdulillah",
      meaning: "All praise is for Allah",
      defaultTarget: 33,
    ),
    DhikrPreset(
      arabic: "ٱللَّهُ أَكْبَرُ",
      transliteration: "Allahu Akbar",
      meaning: "Allah is the Greatest",
      defaultTarget: 33,
    ),
    DhikrPreset(
      arabic: "أَسْتَغْفِرُ ٱللَّهَ",
      transliteration: "Astaghfirullah",
      meaning: "I seek forgiveness from Allah",
      defaultTarget: 100,
    ),
    DhikrPreset(
      arabic: "لَا إِلَٰهَ إِلَّا ٱللَّهُ",
      transliteration: "La ilaha illallah",
      meaning: "There is no deity except Allah",
      defaultTarget: 100,
    ),
    DhikrPreset(
      arabic: "سُبْحَانَ ٱللَّهِ وَبِحَمْدِهِ",
      transliteration: "SubhanAllahi wa bihamdihi",
      meaning: "Glory be to Allah and His is the praise",
      defaultTarget: 100,
    ),
    DhikrPreset(
      arabic: "ٱللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ",
      transliteration: "Allahumma salli 'ala Muhammad",
      meaning: "O Allah, send blessings upon Muhammad",
      defaultTarget: 100,
    ),
  ];

  static const List<int> _targetOptions = [33, 99, 100, 1000];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.94,
      upperBound: 1.0,
    )..value = 1.0;

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapBead() {
    if (_hapticsEnabled) {
      HapticFeedback.lightImpact();
    }

    // Trigger slight spring animation
    _animController.reverse().then((_) => _animController.forward());

    setState(() {
      _counter++;
      _totalCount++;

      if (_counter >= _selectedTarget) {
        _counter = 0;
        _laps++;
        if (_hapticsEnabled) {
          HapticFeedback.heavyImpact();
        }
        _showGoalCelebration();
      }
    });
  }

  void _showGoalCelebration() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.goldWarm),
            const SizedBox(width: 8),
            Text(
              "Masha'Allah! Completed $_selectedTarget ${_dhikrPresets[_selectedDhikrIndex].transliteration}!",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.emeraldDeep,
      ),
    );
  }

  void _resetCounter() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset Tasbih?"),
        content: const Text("Are you sure you want to reset the current count?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emeraldPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _counter = 0;
                _laps = 0;
              });
              Navigator.pop(ctx);
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentDhikr = _dhikrPresets[_selectedDhikrIndex];
    final progress = _selectedTarget > 0 ? (_counter / _selectedTarget).clamp(0.0, 1.0) : 0.0;

    return SafeArea(
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedBackButton(onPressed: widget.onBack),
                Column(
                  children: [
                    const Text(
                      "Digital Tasbih",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.goldWarm),
                    ),
                    Text(
                      "Daily Dhikr & Remembrance",
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _hapticsEnabled ? Icons.vibration_rounded : Icons.smartphone_rounded,
                        color: _hapticsEnabled ? AppColors.goldWarm : Colors.grey,
                        size: 22,
                      ),
                      tooltip: "Haptic Vibration",
                      onPressed: () => setState(() => _hapticsEnabled = !_hapticsEnabled),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 22),
                      tooltip: "Reset",
                      onPressed: _resetCounter,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                // Dhikr Selector Carousel
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dhikrPresets.length,
                    itemBuilder: (ctx, idx) {
                      final isSelected = idx == _selectedDhikrIndex;
                      final dhikr = _dhikrPresets[idx];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDhikrIndex = idx;
                            _selectedTarget = dhikr.defaultTarget;
                            _counter = 0;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: isSelected ? AppColors.tasbihGradient : null,
                            color: isSelected ? null : (isDark ? Colors.white.withOpacity(0.06) : Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.emeraldLight
                                  : (isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dhikr.transliteration,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.lightTextPrimary),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),

                // Selected Dhikr Display Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? const LinearGradient(colors: [Color(0xFF064E3B), Color(0xFF062E23)])
                        : const LinearGradient(colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)]),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.emeraldLight.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emeraldDeep.withOpacity(isDark ? 0.3 : 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentDhikr.arabic,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.emeraldDeep,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentDhikr.transliteration,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\"${currentDhikr.meaning}\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Target Selector Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Target: ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ..._targetOptions.map((t) {
                      final isSelected = _selectedTarget == t;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedTarget = t;
                          if (_counter >= t) _counter = 0;
                        }),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.goldWarm
                                : (isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "$t",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.grey.shade700),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 24),

                // Main Interactive Bead Dial
                Center(
                  child: GestureDetector(
                    onTap: _onTapBead,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Circular Progress Indicator
                            SizedBox(
                              width: 240,
                              height: 240,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 8,
                                backgroundColor: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                                color: AppColors.emeraldLight,
                              ),
                            ),

                            // Outer Gilded Ring
                            Container(
                              width: 216,
                              height: 216,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isDark
                                    ? const LinearGradient(
                                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : const LinearGradient(
                                        colors: [Colors.white, Color(0xFFF8FAFC)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                border: Border.all(
                                  color: AppColors.goldWarm.withOpacity(0.5),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.emeraldPrimary.withOpacity(isDark ? 0.4 : 0.2),
                                    blurRadius: 28,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$_counter",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 64,
                                      fontWeight: FontWeight.w900,
                                      color: isDark ? Colors.white : AppColors.emeraldDeep,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  Text(
                                    "/ $_selectedTarget",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.goldLight : AppColors.goldRoyal,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.emeraldPrimary.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      "TAP TO COUNT",
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: AppColors.emeraldPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Statistics Row: Laps & Total Count
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "COMPLETED LAPS",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$_laps",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.goldWarm),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEEF2FF),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "TOTAL DHIKR TODAY",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$_totalCount",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.emeraldPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
