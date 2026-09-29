import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/storage_service.dart';
import '../../data/repositories/islamic_knowledge_repository.dart';
import 'islamic_ai_service.dart';
import 'widgets/3d/mia_astra_mini_orb.dart';
import 'widgets/3d/holographic_3d_card.dart';

class MyIslamAiSheet extends StatefulWidget {
  final Function(String route) onNavigate;

  const MyIslamAiSheet({super.key, required this.onNavigate});

  static void show(BuildContext context, {required Function(String route) onNavigate}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MyIslamAiSheet(onNavigate: onNavigate),
    );
  }

  @override
  State<MyIslamAiSheet> createState() => _MyIslamAiSheetState();
}

class _MyIslamAiSheetState extends State<MyIslamAiSheet> with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Consultation flow state
  int _consultStep = 0; // 0 = off, 1 = what happened, 2 = feelings, 3 = ready
  final TextEditingController _consultWhatController = TextEditingController();
  final TextEditingController _consultExtraController = TextEditingController();
  final List<String> _consultFeelings = [];

  static const List<String> _feelings = [
    'Anxious',
    'Sad',
    'Angry',
    'Lonely',
    'Guilty',
    'Overwhelmed',
    'Lost',
    'Hopeless',
    'Confused',
    'Grieving',
  ];

  static const List<String> _suggestedQuestions = [
    "What should I do right now?",
    "How's my streak — what's my next step?",
    "What's special about today?",
    "Suggest an adhkar for now",
  ];

  bool _showAppGuide = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _nameController.dispose();
    _consultWhatController.dispose();
    _consultExtraController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(IslamicAiService aiService, StorageService storage) {
    final text = _inputController.text.trim();
    if (text.isEmpty || aiService.isTyping) return;
    _inputController.clear();

    aiService.sendMessage(
      text,
      streak: storage.streak,
      prayersCompleted: storage.prayersCompleted,
      quranPages: storage.quranPagesRead,
      duasRead: storage.duasRead,
      nextPrayer: _computeNextPrayer(storage),
      minutesToNextPrayer: 45,
    );
    _scrollToBottom();
  }

  void _handleQuickPrompt(IslamicAiService aiService, StorageService storage, String prompt) {
    aiService.sendMessage(
      prompt,
      streak: storage.streak,
      prayersCompleted: storage.prayersCompleted,
      quranPages: storage.quranPagesRead,
      duasRead: storage.duasRead,
      nextPrayer: _computeNextPrayer(storage),
      minutesToNextPrayer: 45,
    );
    _scrollToBottom();
  }

  String _computeNextPrayer(StorageService storage) {
    final all = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
    for (final p in all) {
      if (!storage.prayersCompleted.contains(p)) {
        return p;
      }
    }
    return "Fajr (Tomorrow)";
  }

  void _submitConsultation(IslamicAiService aiService, StorageService storage) {
    final feelingsStr = _consultFeelings.isNotEmpty ? _consultFeelings.join(', ') : 'not specified';
    final extra = _consultExtraController.text.trim().isNotEmpty
        ? "\nAdditional context: ${_consultExtraController.text.trim()}"
        : "";

    final prompt =
        "[CONSULTATION MODE]\nWhat happened: ${_consultWhatController.text.trim()}\nHow I feel: $feelingsStr$extra";

    setState(() {
      _consultStep = 0;
      _consultWhatController.clear();
      _consultExtraController.clear();
      _consultFeelings.clear();
    });

    aiService.sendMessage(
      prompt,
      streak: storage.streak,
      prayersCompleted: storage.prayersCompleted,
      quranPages: storage.quranPagesRead,
      duasRead: storage.duasRead,
    );
    _scrollToBottom();
  }

  void _handleSaveName(StorageService storage, IslamicAiService aiService) {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      storage.setUserName(name);
      aiService.setUserName(name);
      _nameController.clear();
    }
  }

  void _handlePrayerAnswer(StorageService storage, IslamicAiService aiService, String prayerName, bool prayed) {
    if (prayed) {
      if (!storage.prayersCompleted.contains(prayerName)) {
        storage.togglePrayer(prayerName);
      }
      aiService.sendMessage(
        "Alhamdulillah, I have completed my $prayerName prayer!",
        streak: storage.streak,
        prayersCompleted: storage.prayersCompleted,
        quranPages: storage.quranPagesRead,
        duasRead: storage.duasRead,
      );
    } else {
      aiService.sendMessage(
        "I have not prayed $prayerName yet. What can motivate me?",
        streak: storage.streak,
        prayersCompleted: storage.prayersCompleted,
        quranPages: storage.quranPagesRead,
        duasRead: storage.duasRead,
      );
    }
    _scrollToBottom();
  }

  void _goTo(String route) {
    Navigator.pop(context);
    widget.onNavigate(route);
  }

  @override
  Widget build(BuildContext context) {
    final aiService = context.watch<IslamicAiService>();
    final storage = context.watch<StorageService>();
    final sheetHeight = MediaQuery.of(context).size.height * 0.88;

    // Synchronize username and API key if available
    if (storage.userName != null && aiService.userName != storage.userName) {
      aiService.setUserName(storage.userName);
    }
    if (storage.geminiApiKey != null) {
      aiService.setApiKey(storage.geminiApiKey);
    }

    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3D1A78),
            Color(0xFF5B2CA8),
            Color(0xFF7C3AED),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 36,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ambient glow elements
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC026D3).withOpacity(0.22),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFA78BFA).withOpacity(0.18),
              ),
            ),
          ),

          // Main Column
          Column(
            children: [
              // 1. Header (MIA Branding, Close, Clear, Audience Mode)
              _buildHeader(aiService, storage),

              // 2. Audience Mode Toggle (Muslim Companion vs Exploring Islam)
              _buildAudienceToggle(aiService),

              // 3. Quick Action Navigation Pills
              _buildQuickActionsBar(aiService),

              // 4. Heart-to-Heart Consultation Wizard (if active)
              if (_consultStep > 0) _buildConsultationCard(aiService, storage),

              // 5. First-Time Name Prompt (if username not yet set)
              if (storage.userName == null && _consultStep == 0)
                _buildNamePromptCard(storage, aiService),

              // 6. Proactive Prayer Check-in (if applicable)
              if (storage.userName != null && _consultStep == 0 && !_showAppGuide)
                _buildPrayerCheckInCard(storage, aiService),

              // 7. Middle Content: Either App Guide or Chat Message Area
              Expanded(
                child: _showAppGuide ? _buildAppGuideView() : _buildChatArea(aiService, storage),
              ),

              // 8. Bottom Input Bar
              if (!_showAppGuide) _buildInputBar(aiService, storage),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(IslamicAiService aiService, StorageService storage) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              // Animated Mini Orb Avatar
              MiaAstraMiniOrb(
                size: 44,
                isThinking: aiService.isTyping,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "MIA",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Text(
                            "AI COMPANION",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFDE047),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      storage.userName != null
                          ? "Assalamu Alaikum, ${storage.userName} • Your Islamic Guide"
                          : "Your personal Islamic companion & guide",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),

              // Clear chat button
              if (aiService.messages.length > 1)
                IconButton(
                  tooltip: "Clear chat",
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.white.withOpacity(0.75), size: 20),
                  onPressed: () => aiService.clearChat(),
                ),

              // App Guide toggle button
              IconButton(
                tooltip: _showAppGuide ? "Back to Chat" : "App Guide",
                icon: Icon(
                  _showAppGuide ? Icons.chat_bubble_outline_rounded : Icons.explore_outlined,
                  color: Colors.white.withOpacity(0.75),
                  size: 20,
                ),
                onPressed: () => setState(() => _showAppGuide = !_showAppGuide),
              ),

              // Close button
              IconButton(
                tooltip: "Close",
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceToggle(IslamicAiService aiService) {
    final isMuslim = aiService.audienceMode == AiAudienceMode.muslim;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => aiService.setAudienceMode(AiAudienceMode.muslim),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  gradient: isMuslim
                      ? const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🌙", style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 5),
                    Text(
                      "Muslim Companion",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isMuslim ? FontWeight.bold : FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => aiService.setAudienceMode(AiAudienceMode.seeker),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  gradient: !isMuslim
                      ? const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🕊️", style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 5),
                    Text(
                      "Exploring Islam",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: !isMuslim ? FontWeight.bold : FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsBar(IslamicAiService aiService) {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(top: 8, bottom: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildActionPill(
            icon: Icons.access_time_rounded,
            label: "Prayer Times",
            gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)]),
            onTap: () => _goTo("prayer"),
          ),
          const SizedBox(width: 6),
          _buildActionPill(
            icon: Icons.menu_book_rounded,
            label: "Qur'an",
            gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF14B8A6)]),
            onTap: () => _goTo("quran"),
          ),
          const SizedBox(width: 6),
          _buildActionPill(
            icon: Icons.favorite_rounded,
            label: "Duas",
            gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFF43F5E)]),
            onTap: () => _goTo("duas"),
          ),
          const SizedBox(width: 6),
          _buildActionPill(
            icon: Icons.explore_rounded,
            label: "Qiblah",
            gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFF97316)]),
            onTap: () => _goTo("qiblah"),
          ),
          const SizedBox(width: 6),
          _buildActionPill(
            icon: Icons.nights_stay_rounded,
            label: "Fasting",
            gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)]),
            onTap: () => _goTo("fasting"),
          ),
          const SizedBox(width: 6),
          _buildActionPill(
            icon: Icons.volunteer_activism_rounded,
            label: "Heart-to-Heart",
            gradient: const LinearGradient(colors: [Color(0xFFA855F7), Color(0xFF6366F1)]),
            onTap: () => setState(() => _consultStep = 1),
          ),
          const SizedBox(width: 6),
          _buildActionPill(
            icon: Icons.trip_origin_rounded,
            label: "Tasbih",
            gradient: const LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF0D9488)]),
            onTap: () => _goTo("tasbih"),
          ),
          const SizedBox(width: 6),
          _buildActionPill(
            icon: Icons.calendar_month_rounded,
            label: "Calendar",
            gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
            onTap: () => _goTo("calendar"),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPill({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 13),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationCard(IslamicAiService aiService, StorageService storage) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 3)),
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
                  const Icon(Icons.volunteer_activism_rounded, color: Color(0xFFF5D0FE), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    "Heart-to-Heart • Step $_consultStep of 3",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                onPressed: () => setState(() => _consultStep = 0),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Progress indicator
          Row(
            children: [1, 2, 3].map((step) {
              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: step <= _consultStep ? const Color(0xFFF5D0FE) : Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Step 1: What happened?
          if (_consultStep == 1) ...[
            const Text(
              "What happened?",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              "Describe the situation in your own words. Nothing leaves this session.",
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _consultWhatController,
              maxLines: 3,
              style: const TextStyle(color: Color(0xFF3D1A78), fontSize: 13),
              decoration: InputDecoration(
                hintText: "Tell me what's going on...",
                hintStyle: TextStyle(color: const Color(0xFF7C3AED).withOpacity(0.5), fontSize: 12),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3D1A78),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                label: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: _consultWhatController.text.trim().length >= 3
                    ? () => setState(() => _consultStep = 2)
                    : null,
              ),
            ),
          ],

          // Step 2: How are you feeling?
          if (_consultStep == 2) ...[
            const Text(
              "How are you feeling?",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              "Tap all that apply.",
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _feelings.map((f) {
                final isSelected = _consultFeelings.contains(f);
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _consultFeelings.remove(f);
                      } else {
                        _consultFeelings.add(f);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white24,
                      ),
                    ),
                    child: Text(
                      isSelected ? "✓ $f" : f,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xFF3D1A78) : Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => setState(() => _consultStep = 1),
                  child: const Text("Back", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF3D1A78),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                  label: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: () => setState(() => _consultStep = 3),
                ),
              ],
            ),
          ],

          // Step 3: Ready for guidance
          if (_consultStep == 3) ...[
            const Text(
              "Ready for Islamic Guidance",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              "MIA will reply with empathy, Quran & Sunnah reassurance, a dua, and 3 actionable steps.",
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Situation: ${_consultWhatController.text.trim()}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 11.5),
                  ),
                  if (_consultFeelings.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Feelings: ${_consultFeelings.join(', ')}",
                      style: const TextStyle(color: Color(0xFFF5D0FE), fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => setState(() => _consultStep = 2),
                  child: const Text("Back", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.auto_awesome_rounded, size: 14),
                  label: const Text("Get Guidance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: () => _submitConsultation(aiService, storage),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNamePromptCard(StorageService storage, IslamicAiService aiService) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Icon(Icons.badge_rounded, color: Color(0xFFFDE047), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What should I call you?",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.5),
                ),
                const SizedBox(height: 2),
                Text(
                  "So I can greet you personally, insha'Allah.",
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10.5),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 90,
            height: 34,
            child: TextField(
              controller: _nameController,
              style: const TextStyle(fontSize: 12, color: Color(0xFF3D1A78)),
              decoration: InputDecoration(
                hintText: "Your name",
                hintStyle: TextStyle(fontSize: 11, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF3D1A78),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: const Size(40, 34),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            onPressed: () => _handleSaveName(storage, aiService),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCheckInCard(StorageService storage, IslamicAiService aiService) {
    final nextPrayer = _computeNextPrayer(storage);
    if (nextPrayer.contains("Tomorrow")) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_filled_rounded, color: Color(0xFF38BDF8), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "${storage.userName ?? 'Friend'}, have you prayed $nextPrayer?",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handlePrayerAnswer(storage, aiService, nextPrayer, true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "✓ Yes",
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handlePrayerAnswer(storage, aiService, nextPrayer, false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Not yet",
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(IslamicAiService aiService, StorageService storage) {
    if (aiService.messages.isEmpty) {
      return _buildEmptyState(aiService, storage);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: aiService.messages.length + (aiService.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= aiService.messages.length) {
          return _buildTypingBubble();
        }

        final msg = aiService.messages[index];
        return _buildMessageItem(msg);
      },
    );
  }

  Widget _buildEmptyState(IslamicAiService aiService, StorageService storage) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text("Assalamu Alaikum 👋", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "I know your streak (${storage.streak} days), next prayer, and the Islamic date. Ask me what to do right now, or explore any question about Islam!",
                style: TextStyle(fontSize: 12.5, height: 1.4, color: Colors.white.withOpacity(0.85)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "TRY ASKING",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.white.withOpacity(0.6)),
        ),
        const SizedBox(height: 8),
        ..._suggestedQuestions.map((q) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _handleQuickPrompt(aiService, storage, q),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        q,
                        style: const TextStyle(fontSize: 12.5, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white60, size: 16),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMessageItem(AiChatMessage msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.white : Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
                      bottomLeft: !isUser ? const Radius.circular(4) : const Radius.circular(20),
                    ),
                    border: Border.all(
                      color: isUser ? Colors.white : Colors.white.withOpacity(0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // Arabic Box if provided
                      if (msg.arabicReference != null) ...[
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFDE047).withOpacity(0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                msg.arabicReference!,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.amiriQuran(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFDE047),
                                ),
                              ),
                              if (msg.englishReference != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  msg.englishReference!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],

                      // Message Body
                      Text(
                        msg.text,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: isUser ? const Color(0xFF3D1A78) : Colors.white,
                          fontWeight: isUser ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                // Interactive Quick Action Buttons underneath message bubble
                if (!isUser && msg.actions.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: msg.actions.map((act) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _goTo(act.route),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFC026D3)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(act.icon, size: 12, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                "Open ${act.label}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.arrow_forward_rounded, size: 11, color: Colors.white70),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(150),
                const SizedBox(width: 4),
                _buildDot(300),
                const SizedBox(width: 8),
                Text(
                  "MIA is reflecting...",
                  style: TextStyle(fontSize: 11.5, color: Colors.white.withOpacity(0.75)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int delayMs) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildAppGuideView() {
    const features = IslamicAiService.appFeatures;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final f = features[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Holographic3dCard(
            padding: const EdgeInsets.all(14),
            borderRadius: BorderRadius.circular(20),
            onTap: () => _goTo(f.route),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: AppColors.astraTrilateralGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(f.icon, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(f.subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.goldRoyal)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.goldWarm),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  f.description,
                  style: TextStyle(fontSize: 11.5, height: 1.4, color: Colors.white.withOpacity(0.85)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputBar(IslamicAiService aiService, StorageService storage) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.12))),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                      ],
                    ),
                    child: TextField(
                      controller: _inputController,
                      onSubmitted: (_) => _handleSend(aiService, storage),
                      style: const TextStyle(color: Color(0xFF3D1A78), fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Ask MIA anything about Quran, Salah, or your day...",
                        hintStyle: TextStyle(fontSize: 12, color: const Color(0xFF7C3AED).withOpacity(0.5)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () => _handleSend(aiService, storage),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Responses are grounded in authentic Islamic sources. Consult scholars for personal fatwas.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9.5, color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
