import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import 'islamic_ai_service.dart';

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

  final List<String> _quickSuggestions = [
    "🧭 App Tour & Guide",
    "🤲 Dua for peace & anxiety",
    "📖 Virtues of Surah Al-Mulk",
    "📿 Recommended Dhikr today",
    "🕋 How to find Qiblah?",
    "💰 How do I calculate Zakat?",
    "🌙 Fasting intentions & rules",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
          _buildHeader(isDark),

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

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF064E3B).withOpacity(0.4), Colors.transparent]
              : [const Color(0xFFECFDF5), Colors.white],
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
              // Animated AI Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.goldWarm, AppColors.emeraldPrimary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldWarm.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
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
                            color: AppColors.emeraldPrimary.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.emeraldPrimary.withOpacity(0.4)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, color: AppColors.emeraldLight, size: 6),
                              SizedBox(width: 4),
                              Text(
                                "Guide & Sunnah",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.emeraldPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Your interactive app navigator and spiritual companion",
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

  Widget _buildChatTab(bool isDark, IslamicAiService aiService) {
    return Column(
      children: [
        // Quick suggestion chips bar
        Container(
          height: 38,
          margin: const EdgeInsets.only(top: 4, bottom: 6),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _quickSuggestions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final chip = _quickSuggestions[index];
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
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.goldWarm, AppColors.emeraldPrimary],
                ),
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
                    ? AppColors.emeraldPrimary
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : null,
                  bottomLeft: !isUser ? const Radius.circular(4) : null,
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
              gradient: LinearGradient(colors: [AppColors.goldWarm, AppColors.emeraldPrimary]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.goldWarm,
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
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
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
                  fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.emeraldPrimary, width: 1.5),
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
                  colors: [AppColors.emeraldPrimary, Color(0xFF047857)],
                ),
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
    final features = IslamicAiService.appFeatures;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final f = features[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.goldWarm.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.goldWarm.withOpacity(0.35)),
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
                      backgroundColor: AppColors.emeraldPrimary,
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
                        const Icon(Icons.check_circle_rounded, color: AppColors.emeraldPrimary, size: 12),
                        const SizedBox(width: 4),
                        Text(h, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
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
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
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
                    backgroundColor: AppColors.emeraldPrimary,
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
        );
      },
    );
  }
}
