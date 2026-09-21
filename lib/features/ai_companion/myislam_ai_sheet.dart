import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/islamic_knowledge_repository.dart';
import 'islamic_ai_service.dart';
import 'widgets/3d/mia_astra_3d_orb.dart';
import 'widgets/3d/mia_astra_mini_orb.dart';
import 'widgets/3d/mia_3d_companion_stage.dart';
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
  late TabController _tabController;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _is3dStageExpanded = true;

  final List<String> _muslimSuggestions = [
    "🧭 App Tour & Guide",
    "🤲 Dua for peace & anxiety",
    "📖 Virtues of Surah Al-Mulk",
    "📿 Recommended Dhikr today",
    "🕋 How to find Qiblah?",
    "💰 How do I calculate Zakat?",
    "🌙 Fasting intentions & rules",
    "❓ Forgot a Rak'ah in Salah?",
    "❓ Swallowed water by mistake in fasting?",
    "❓ What breaks Wudu?",
    "🤲 How to make sincere Tawbah?",
  ];

  final List<String> _seekerSuggestions = [
    "🧭 App Tour & Guide",
    "🕊️ What is the core message of Islam?",
    "✨ Who is Allah?",
    "📖 Who is Jesus (Isa) in Islam?",
    "🌸 What is the status of women in Islam?",
    "🔬 Does the Quran agree with science?",
    "🌟 How does someone become a Muslim?",
    "🤝 Are non-Muslims welcomed in mosques?",
    "❓ Why do Muslims pray 5 times a day?",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _inputController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  MiaOrbState _currentOrbState(IslamicAiService aiService) {
    if (aiService.isTyping) return MiaOrbState.thinking;
    if (_inputController.text.trim().isNotEmpty) return MiaOrbState.listening;
    if (aiService.messages.isNotEmpty && !aiService.messages.last.isUser) {
      final diff = DateTime.now().difference(aiService.messages.last.timestamp);
      if (diff.inSeconds < 4) return MiaOrbState.speaking;
    }
    return MiaOrbState.idle;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
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

  void _handleSend(IslamicAiService aiService) {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    aiService.sendMessage(text);
    _scrollToBottom();
  }

  void _handleQuickChip(IslamicAiService aiService, String prompt) {
    if (prompt.contains("App Tour")) {
      _tabController.animateTo(1);
      return;
    }
    aiService.sendMessage(prompt);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final aiService = context.watch<IslamicAiService>();
    final sheetHeight = MediaQuery.of(context).size.height * 0.88;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.5 : 0.25),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Top Decorative Header & Branding
          _buildHeader(isDark, aiService),

          // Audience Mode Switcher (Muslim Companion vs Exploring Islam)
          _buildAudienceToggle(isDark, aiService),

          // 3D Interactive Astra Companion Stage
          Mia3dCompanionStage(
            state: _currentOrbState(aiService),
            isExpanded: _is3dStageExpanded,
            onToggleExpand: () => setState(() => _is3dStageExpanded = !_is3dStageExpanded),
            onSelectPrompt: (prompt) => _handleQuickChip(aiService, prompt),
          ),

          const SizedBox(height: 4),

          // 2. Navigation Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.islamicGold,
              unselectedLabelColor: isDark ? Colors.white60 : Colors.grey,
              indicatorColor: AppColors.islamicGold,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(
                  icon: Icon(Icons.auto_awesome_rounded, size: 16),
                  text: "AI Assistant",
                ),
                Tab(
                  icon: Icon(Icons.explore_rounded, size: 16),
                  text: "App Guide",
                ),
                Tab(
                  icon: Icon(Icons.lightbulb_rounded, size: 16),
                  text: "Islamic Pearls",
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 3. Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: Chat Assistant
                _buildChatTab(isDark, aiService),

                // TAB 2: App Guide & Tour
                _buildGuideTab(isDark),

                // TAB 3: Islamic Pearls
                _buildPearlsTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, IslamicAiService aiService) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2E1065).withOpacity(0.4), Colors.transparent]
              : [const Color(0xFFF0F9FF), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              // Animated 3D Astra Mini Orb Avatar
              MiaAstraMiniOrb(
                size: 46,
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
                          "MyIslam AI",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: AppColors.astraTrilateralGradient,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.astraSkyLight.withOpacity(0.35),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 10),
                              SizedBox(width: 4),
                              Text(
                                "ASTRA 3D",
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Friendly 3D Islamic companion & interactive guide",
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceToggle(bool isDark, IslamicAiService aiService) {
    final isMuslim = aiService.audienceMode == AiAudienceMode.muslim;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => aiService.setAudienceMode(AiAudienceMode.muslim),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: isMuslim ? AppColors.purpleGoldShiningGradient : null,
                  color: isMuslim ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isMuslim
                      ? [
                          BoxShadow(
                            color: AppColors.islamicGold.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🌙", style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 6),
                    Text(
                      "Muslim Companion",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isMuslim ? FontWeight.bold : FontWeight.w500,
                        color: isMuslim ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
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
              borderRadius: BorderRadius.circular(18),
              onTap: () => aiService.setAudienceMode(AiAudienceMode.seeker),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: !isMuslim ? AppColors.purpleGoldShiningGradient : null,
                  color: !isMuslim ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: !isMuslim
                      ? [
                          BoxShadow(
                            color: AppColors.islamicGold.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🕊️", style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 6),
                    Text(
                      "Exploring Islam",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: !isMuslim ? FontWeight.bold : FontWeight.w500,
                        color: !isMuslim ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
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

  Widget _buildChatTab(bool isDark, IslamicAiService aiService) {
    final suggestions = aiService.audienceMode == AiAudienceMode.muslim
        ? _muslimSuggestions
        : _seekerSuggestions;

    return Column(
      children: [
        // Quick suggestion chips bar
        Container(
          height: 38,
          margin: const EdgeInsets.only(top: 4, bottom: 6),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final chip = suggestions[index];
              return ActionChip(
                label: Text(chip, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                backgroundColor: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9),
                side: BorderSide(
                  color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () => _handleQuickChip(aiService, chip),
              );
            },
          ),
        ),

        // Message List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: aiService.messages.length + (aiService.isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= aiService.messages.length) {
                // Typing Indicator Bubble
                return _buildTypingIndicator(isDark);
              }

              final msg = aiService.messages[index];
              return _buildMessageBubble(msg, isDark);
            },
          ),
        ),

        // Bottom Input Field
        _buildInputBar(isDark, aiService),
      ],
    );
  }

  Widget _buildMessageBubble(AiChatMessage msg, bool isDark) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: const BoxDecoration(
                gradient: AppColors.purpleGoldShiningGradient,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.islamicPurple
                    : (isDark ? AppColors.darkCardBg : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : null,
                  bottomLeft: !isUser ? const Radius.circular(4) : null,
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Arabic Reference if available
                  if (msg.arabicReference != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.goldWarm.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.goldWarm.withOpacity(0.3)),
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
                              color: AppColors.goldRoyal,
                            ),
                          ),
                          if (msg.englishReference != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              msg.englishReference!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: isDark ? Colors.white70 : Colors.grey[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  // Main Text Content
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: isUser
                          ? Colors.white
                          : (isDark ? Colors.white.withOpacity(0.95) : const Color(0xFF1E293B)),
                    ),
                  ),

                  // Action Button to Navigate in App
                  if (msg.suggestedRoute != null && msg.suggestedRouteLabel != null) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldWarm,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                      label: Text(
                        msg.suggestedRouteLabel!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onNavigate(msg.suggestedRoute!);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              gradient: AppColors.purpleGoldShiningGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.islamicGold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "MyIslam AI is thinking...",
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isDark, IslamicAiService aiService) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                onSubmitted: (_) => _handleSend(aiService),
                decoration: InputDecoration(
                  hintText: "Ask anything about Quran, Duas, or the app...",
                  hintStyle: TextStyle(fontSize: 12.5, color: isDark ? Colors.white38 : Colors.grey[500]),
                  filled: true,
                  fillColor: isDark ? AppColors.darkCardBg : const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.islamicGold, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                gradient: AppColors.purpleGoldShiningGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                onPressed: () => _handleSend(aiService),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideTab(bool isDark) {
    const features = IslamicAiService.appFeatures;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final f = features[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Holographic3dCard(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(f.route);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.astraTrilateralGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.astraSkyLight.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(f.icon, style: const TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(f.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.goldRoyal)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.islamicPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Open", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 14),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onNavigate(f.route);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  f.description,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: f.highlights.map((h) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.islamicGold, size: 12),
                          const SizedBox(width: 4),
                          Text(h, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPearlsTab(bool isDark) {
    final pearls = [
      {
        "title": "The Beauty of Morning & Evening Dhikr",
        "arabic": "فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ",
        "translation": "“So remember Me; I will remember you. And be grateful to Me and do not deny Me.” (2:152)",
        "explanation": "Starting and ending your day with the remembrance of Allah creates an impenetrable spiritual fortress protecting you and your family.",
        "action": "Open Morning Duas",
        "route": "duas",
      },
      {
        "title": "Surah Al-Mulk Before Sleep",
        "arabic": "تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
        "translation": "“Blessed is He in whose hand is dominion, and He is over all things competent.” (67:1)",
        "explanation": "Reciting Surah Al-Mulk every night shields against the trials of the grave. You can read it directly in our authentic Madani Mushaf reader!",
        "action": "Read Surah Al-Mulk",
        "route": "quran",
      },
      {
        "title": "Tactile Dhikr & Counting on Fingers / Tasbih",
        "arabic": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، عَدَدَ خَلْقِهِ ، وَرِضَا نَفْسِهِ",
        "translation": "“Glory and praise be to Allah according to the number of His creation, His pleasure...”",
        "explanation": "Engage your mind and hands with steady Dhikr after every obligatory Salah using the MyIslam Digital Tasbih.",
        "action": "Launch Digital Tasbih",
        "route": "tasbih",
      },
      {
        "title": "Purifying Your Wealth with Zakat",
        "arabic": "وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ",
        "translation": "“And establish prayer and give zakah...” (2:43)",
        "explanation": "Giving 2.5% of your qualifying surplus wealth does not decrease wealth; rather it blesses, purifies, and multiplies it.",
        "action": "Calculate Zakat",
        "route": "zakat",
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: pearls.length,
      itemBuilder: (context, index) {
        final p = pearls[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Holographic3dCard(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(p["route"]!);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppColors.goldWarm, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.goldWarm.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.goldWarm.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        p["arabic"]!,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiriQuran(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldRoyal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p["translation"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: isDark ? Colors.white70 : Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  p["explanation"]!,
                  style: TextStyle(fontSize: 12.5, height: 1.45, color: isDark ? Colors.white70 : Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.islamicPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                    label: Text(p["action"]!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onNavigate(p["route"]!);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
