import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MIAAssistantSheet extends StatefulWidget {
  const MIAAssistantSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MIAAssistantSheet(),
    );
  }

  @override
  State<MIAAssistantSheet> createState() => _MIAAssistantSheetState();
}

class _MIAAssistantSheetState extends State<MIAAssistantSheet> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      "sender": "mia",
      "text": "Assalamu alaikum wa Rahmatullah 👋\n\nI am MIA, your personal Islamic companion. The time for prayer has entered. How may I assist your spiritual journey today?",
    },
  ];

  void _sendMessage([String? preset]) {
    final text = preset ?? _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      if (preset == null) _textController.clear();
    });

    // Simulate MIA response
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        String reply = "Masha'Allah! May Allah bless your efforts and accept your worship. Remember: \"Indeed, prayer restrains from shameful and unjust deeds.\" (Quran 29:45)";
        if (text.toLowerCase().contains("dua")) {
          reply = "Here is a powerful dua: \"Allahumma inni as'aluka ilman nafi'an, wa rizqan tayyiban, wa 'amalan mutaqabbala.\" (O Allah, I ask You for beneficial knowledge, good provision and accepted deeds).";
        } else if (text.toLowerCase().contains("yes")) {
          reply = "Alhamdulillah! May Allah accept your prayer. Here is the post-Salah remembrance: Astaghfirullah (3x), Allahumma antas-salamu wa minkas-salam.";
        } else if (text.toLowerCase().contains("not yet")) {
          reply = "Take your time to make a mindful wudhu. The Prophet ﷺ said: 'The best of deeds is the prayer performed on time.'";
        }
        _messages.add({"sender": "mia", "text": reply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F0C29) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark ? AppColors.islamicGold.withOpacity(0.3) : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          // Header handle & title
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.heroPrayerGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("MIA Assistant", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Your Islamic AI Companion", style: TextStyle(fontSize: 11, color: Color(0xFF818CF8))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isUser = m["sender"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)])
                          : null,
                      color: isUser ? null : (isDark ? const Color(0xFF1E1B4B) : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isUser ? 18 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 18),
                      ),
                      border: isUser ? null : Border.all(color: isDark ? Colors.white12 : Colors.black12),
                    ),
                    child: Text(
                      m["text"]!,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: isUser ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick prompt chips
          Container(
            height: 36,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildChip("I prayed, Alhamdulillah", () => _sendMessage("Yes, I prayed Alhamdulillah")),
                _buildChip("Give me a Dua for peace", () => _sendMessage("What is a dua for peace and tranquility?")),
                _buildChip("Surah recommendation", () => _sendMessage("Recommend a Surah to recite today")),
              ],
            ),
          ),

          // Input field
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131131) : Colors.white,
              border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Ask MIA anything about Islam...",
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.heroPrayerGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.islamicIndigo.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.islamicIndigo.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.islamicIndigo),
        ),
      ),
    );
  }
}
