import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SpiritualStateSelector extends StatefulWidget {
  final Function(String routeName)? onNavigate;

  const SpiritualStateSelector({super.key, this.onNavigate});

  @override
  State<SpiritualStateSelector> createState() => _SpiritualStateSelectorState();
}

class _SpiritualStateSelectorState extends State<SpiritualStateSelector> {
  int _selectedIndex = 0; // Default: Shukr (Grateful)

  static const List<Map<String, dynamic>> _states = [
    {
      "emoji": "🤲",
      "label": "Grateful",
      "arabic": "شاكر",
      "sub": "Shukr",
      "color": Color(0xFFF59E0B), // Warm Gold
      "verseArabic": "لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ",
      "verseEnglish": "\"If you are grateful, I will surely increase you [in favor].\"",
      "reference": "Surah Ibrahim 14:7",
      "dua": "Alhamdulillah 'ala kulli haal (Praise be to Allah in all circumstances).",
      "route": "quran",
    },
    {
      "emoji": "🕊️",
      "label": "Seeking Peace",
      "arabic": "سكينة",
      "sub": "Sakinah",
      "color": Color(0xFF0EA5E9), // Sky Blue
      "verseArabic": "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
      "verseEnglish": "\"Unquestionably, by the remembrance of Allah hearts are assured.\"",
      "reference": "Surah Ar-Ra'd 13:28",
      "dua": "Allahumma anta as-Salaam wa minka as-Salaam (O Allah, You are Peace and from You is peace).",
      "route": "duas",
    },
    {
      "emoji": "🌧️",
      "label": "In Hardship",
      "arabic": "صابر",
      "sub": "Sabr",
      "color": Color(0xFF6366F1), // Indigo
      "verseArabic": "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا • إِنَّ مَعَ الْعُسْرِ يُسْرًا",
      "verseEnglish": "\"For indeed, with hardship [will be] ease. Indeed, with hardship [will be] ease.\"",
      "reference": "Surah Ash-Sharh 94:5-6",
      "dua": "Hasbunallahu wa ni'mal wakeel (Sufficient for us is Allah, and He is the best Disposer of affairs).",
      "route": "duas",
    },
    {
      "emoji": "📖",
      "label": "Reflective",
      "arabic": "متدبر",
      "sub": "Tadabbur",
      "color": Color(0xFF10B981), // Emerald
      "verseArabic": "أَفَلَا يَتَدَبَّرُونَ الْقُرْآنَ أَمْ عَلَىٰ قُلُوبٍ أَقْفَالُهَا",
      "verseEnglish": "\"Then do they not reflect upon the Qur'an, or are there locks upon their hearts?\"",
      "reference": "Surah Muhammad 47:24",
      "dua": "Rabbi zidni 'ilman (My Lord, increase me in knowledge).",
      "route": "quran",
    },
    {
      "emoji": "💚",
      "label": "Repentant",
      "arabic": "تائب",
      "sub": "Tawbah",
      "color": Color(0xFF8B5CF6), // Soft Purple
      "verseArabic": "إِنَّ اللَّهَ يُحِبُّ التَّوَّابِينَ وَيُحِبُّ الْمُتَطَهِّرِينَ",
      "verseEnglish": "\"Indeed, Allah loves those who are constantly repentant and loves those who purify themselves.\"",
      "reference": "Surah Al-Baqarah 2:222",
      "dua": "Astaghfirullah al-'Azeem wa atoobu ilayh (I seek forgiveness from Allah the Almighty and repent to Him).",
      "route": "duas",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedState = _states[_selectedIndex];
    final stateColor = selectedState["color"] as Color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How is your heart today?",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Select your spiritual state for personalized guidance",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: stateColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                selectedState["sub"] as String,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: stateColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal Mood / State Pill Selector (Inspired by Image 5)
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _states.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final state = _states[index];
              final isSelected = index == _selectedIndex;
              final color = state["color"] as Color;

              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? color.withOpacity(0.25) : color.withOpacity(0.15))
                        : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? color : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                      width: isSelected ? 1.6 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state["emoji"] as String, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        state["label"] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? (isDark ? Colors.white : color)
                              : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Dynamic Prescribed Guidance Card
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: Container(
            key: ValueKey<int>(_selectedIndex),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: stateColor.withOpacity(isDark ? 0.35 : 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: stateColor.withOpacity(isDark ? 0.15 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: stateColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.auto_awesome_rounded, size: 14, color: stateColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Prescription for your Heart",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: stateColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      selectedState["reference"] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Arabic Verse
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: Text(
                    selectedState["verseArabic"] as String,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.8,
                      color: AppColors.islamicGold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 6),

                // English Translation
                Text(
                  selectedState["verseEnglish"] as String,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(height: 1, color: isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
                const SizedBox(height: 8),

                // Prescribed Dua & Action
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Dua: ${selectedState["dua"]}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (widget.onNavigate != null) {
                          widget.onNavigate!(selectedState["route"] as String);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: stateColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Read",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
