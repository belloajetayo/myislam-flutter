import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';
import '../../data/models/prophet_model.dart';
import '../ai_companion/widgets/3d/holographic_3d_card.dart';

class ProphetDetailScreen extends StatefulWidget {
  final ProphetItem prophet;
  final ProphetItem? previousProphet;
  final ProphetItem? nextProphet;
  final Function(ProphetItem prophet)? onSelectProphet;

  const ProphetDetailScreen({
    super.key,
    required this.prophet,
    this.previousProphet,
    this.nextProphet,
    this.onSelectProphet,
  });

  @override
  State<ProphetDetailScreen> createState() => _ProphetDetailScreenState();
}

class _ProphetDetailScreenState extends State<ProphetDetailScreen> {
  bool _isBookmarked = false;
  bool _copiedDua = false;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.mediumImpact();
    setState(() => _copiedDua = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.islamicGold, size: 20),
            const SizedBox(width: 10),
            Text("$label copied to clipboard"),
          ],
        ),
        backgroundColor: const Color(0xFF1E1B4B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedDua = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prophet = widget.prophet;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgStart : AppColors.lightBgStart,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: AnimatedBackButton(
            onPressed: () => Navigator.of(context).pop(),
            tooltip: "Back to Prophets",
          ),
        ),
        title: Text(
          prophet.nameEnglish,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppColors.islamicGold : (isDark ? Colors.white70 : Colors.black87),
            ),
            tooltip: "Bookmark Story",
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() => _isBookmarked = !_isBookmarked);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isBookmarked ? "Saved to your reading list" : "Removed from reading list"),
                  backgroundColor: const Color(0xFF1E1B4B),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share_rounded, color: isDark ? Colors.white70 : Colors.black87),
            tooltip: "Share Story",
            onPressed: () {
              _copyToClipboard(
                "Prophet ${prophet.nameEnglish} (${prophet.nameArabic}) - ${prophet.title}\n\nQuran mentions: ${prophet.quranMentions} times (${prophet.keySurahs})\n\nKey Dua:\n${prophet.keyDuaArabic}\n\n${prophet.keyDuaEnglish} [${prophet.keyDuaReference}]\n\nRead more on MyIslam App.",
                "Prophet ${prophet.nameEnglish}'s story",
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 3D Tilt Hero Calligraphy Banner
            Holographic3dCard(
              padding: const EdgeInsets.all(22),
              borderRadius: 24,
              border: Border.all(color: AppColors.islamicGold.withOpacity(0.55), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.islamicPurpleDeep.withOpacity(0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.astraSky.withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E1B4B), // Deep Indigo
                  Color(0xFF2E1065), // Cosmic Purple
                  Color(0xFF0F172A), // Midnight
                ],
              ),
              child: Column(
                children: [
                  // Order badge & Era
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.astraSky, AppColors.astraPurple],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Prophet #${prophet.order}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.islamicGold.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.islamicGold.withOpacity(0.6), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.history_edu_rounded, color: AppColors.islamicGold, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              prophet.era,
                              style: const TextStyle(
                                color: AppColors.goldLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Arabic Calligraphy in radiant gold
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFFFBEB), Color(0xFFFDE047), Color(0xFFF59E0B)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: Text(
                      prophet.nameArabic,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // English Name & Title
                  Text(
                    prophet.nameEnglish,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prophet.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.astraSkyLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary text
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(
                      prophet.summary,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Metadata Statistics Row
            Row(
              children: [
                Expanded(
                  child: _buildMetaCard(
                    icon: Icons.menu_book_rounded,
                    title: "Quran Mentions",
                    value: "${prophet.quranMentions} Times",
                    subtext: prophet.keySurahs,
                    color: AppColors.astraSky,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetaCard(
                    icon: Icons.place_rounded,
                    title: "Region & Era",
                    value: prophet.historicalLocation,
                    subtext: prophet.era,
                    color: AppColors.islamicGold,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Key Quranic Dua of the Prophet (Highlighted Card)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF1E1B4B),
                          const Color(0xFF2E1065),
                        ]
                      : [
                          const Color(0xFFFAF5FF),
                          const Color(0xFFF3E8FF),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.islamicGold.withOpacity(0.7), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.islamicGold.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: AppColors.purpleGoldShiningGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dua of Prophet ${prophet.nameEnglish}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5,
                                  color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                                ),
                              ),
                              Text(
                                "Supplication from the Quran",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.goldLight : AppColors.islamicGoldDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          _copiedDua ? Icons.check_circle_rounded : Icons.copy_rounded,
                          color: _copiedDua ? AppColors.islamicGreen : AppColors.islamicGold,
                          size: 20,
                        ),
                        tooltip: "Copy Dua",
                        onPressed: () => _copyToClipboard(
                          "${prophet.keyDuaArabic}\n\n${prophet.keyDuaTransliteration}\n\n${prophet.keyDuaEnglish}\n[${prophet.keyDuaReference}]",
                          "Dua of Prophet ${prophet.nameEnglish}",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Arabic Dua text
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black.withOpacity(0.25) : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      prophet.keyDuaArabic,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.8,
                        color: isDark ? const Color(0xFFFEF08A) : const Color(0xFF78350F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Transliteration
                  Text(
                    prophet.keyDuaTransliteration,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      height: 1.45,
                      color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Translation
                  Text(
                    prophet.keyDuaEnglish,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Reference tag
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.islamicPurpleDeep.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.islamicPurple.withOpacity(0.3)),
                      ),
                      child: Text(
                        prophet.keyDuaReference,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.astraSkyLight : AppColors.islamicPurpleDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Miracles Section (Al-Mu'jizat)
            _buildSectionHeader(
              title: "Divine Miracles (المعجزات)",
              subtitle: "Signs granted to verify prophetic truth",
              icon: Icons.flare_rounded,
              color: AppColors.astraGold,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            ...prophet.miracles.map(
              (m) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.islamicGold.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star_rounded, color: AppColors.islamicGold, size: 14),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        m,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Milestones Timeline
            _buildSectionHeader(
              title: "Key Quranic Milestones",
              subtitle: "Major events documented in the Quran",
              icon: Icons.timeline_rounded,
              color: AppColors.astraPurple,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            ...prophet.milestones.asMap().entries.map((entry) {
              final index = entry.key;
              final ms = entry.value;
              final isLast = index == prophet.milestones.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timeline indicator
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            gradient: AppColors.purpleGoldShiningGradient,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: AppColors.islamicPurple.withOpacity(0.35),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Milestone Card
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardBg : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ms.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ms.description,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.45,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            if (ms.quranReference != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.astraSky.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  ms.quranReference!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.astraSky,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Moral Lessons & Reflections
            _buildSectionHeader(
              title: "Spiritual Lessons & Reflection",
              subtitle: "Actionable takeaways for your daily life",
              icon: Icons.lightbulb_rounded,
              color: AppColors.astraSky,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            ...prophet.moralLessons.map(
              (lesson) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF1E293B).withOpacity(0.7),
                            const Color(0xFF0F172A).withOpacity(0.7),
                          ]
                        : [
                            const Color(0xFFF0FDF4),
                            const Color(0xFFECFDF5),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: AppColors.islamicGreen, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lesson,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF065F46),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Previous & Next Navigation Buttons
            Row(
              children: [
                if (widget.previousProphet != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: AppColors.islamicPurple.withOpacity(0.5)),
                      ),
                      onPressed: () {
                        if (widget.onSelectProphet != null) {
                          widget.onSelectProphet!(widget.previousProphet!);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProphetDetailScreen(
                                prophet: widget.previousProphet!,
                                onSelectProphet: widget.onSelectProphet,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_back_rounded, size: 16),
                      label: Text(
                        widget.previousProphet!.nameEnglish,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 12),
                if (widget.nextProphet != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.islamicPurpleDeep,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (widget.onSelectProphet != null) {
                          widget.onSelectProphet!(widget.nextProphet!);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProphetDetailScreen(
                                prophet: widget.nextProphet!,
                                onSelectProphet: widget.onSelectProphet,
                              ),
                            ),
                          );
                        }
                      },
                      label: Text(
                        widget.nextProphet!.nameEnglish,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtext,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              color: isDark ? AppColors.darkTextSecondary.withOpacity(0.8) : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
