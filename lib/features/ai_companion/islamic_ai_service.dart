import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/islamic_knowledge_repository.dart';

class AiMessageAction {
  final String key;
  final String label;
  final String route;
  final IconData icon;

  const AiMessageAction({
    required this.key,
    required this.label,
    required this.route,
    required this.icon,
  });
}

class AiChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? suggestedRoute;
  final String? suggestedRouteLabel;
  final String? arabicReference;
  final String? englishReference;
  final List<AiMessageAction> actions;

  AiChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.suggestedRoute,
    this.suggestedRouteLabel,
    this.arabicReference,
    this.englishReference,
    this.actions = const [],
  }) : timestamp = timestamp ?? DateTime.now();
}

class AppFeatureGuideItem {
  final String title;
  final String subtitle;
  final String icon;
  final String route;
  final String description;
  final List<String> highlights;

  const AppFeatureGuideItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.description,
    required this.highlights,
  });
}

class IslamicAiService extends ChangeNotifier {
  final List<AiChatMessage> _messages = [];
  bool _isTyping = false;
  String? _geminiApiKey;
  String? _userName;
  AiAudienceMode _audienceMode = AiAudienceMode.muslim;

  List<AiChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  AiAudienceMode get audienceMode => _audienceMode;
  String? get userName => _userName;

  IslamicAiService() {
    _initWelcome();
  }

  void setApiKey(String? key) {
    _geminiApiKey = key;
  }

  void setUserName(String? name) {
    _userName = name;
    if (_messages.length <= 1) {
      _initWelcome();
      notifyListeners();
    }
  }

  void setAudienceMode(AiAudienceMode mode) {
    if (_audienceMode != mode) {
      _audienceMode = mode;
      _initWelcome();
      notifyListeners();
    }
  }

  void clearChat() {
    _initWelcome();
    notifyListeners();
  }

  void _initWelcome() {
    _messages.clear();
    final nameGreeting = (_userName != null && _userName!.isNotEmpty) ? ", $_userName" : "";
    if (_audienceMode == AiAudienceMode.seeker) {
      _messages.add(
        AiChatMessage(
          isUser: false,
          text:
              "Welcome$nameGreeting! Peace be upon you 🕊️\n\nI am **MIA (My Islam AI)**, your personal guide and companion to understanding Islam.\n\nWhether you are curious about what Muslims believe, who Jesus is in Islam, the concept of God, scientific reflections in the Quran, or women's rights in Islam, I am here to answer with kindness, clarity, and respect.",
          suggestedRoute: "home",
          suggestedRouteLabel: "Explore App Tour",
          arabicReference:
              "يَا أَيُّهَا النَّاسُ إِنَّا خَلَقْنَاكُم مِّن ذَكَرٍ وَأُنثَىٰ وَجَعَلْنَاكُمْ شُعُوبًا وَقَبَائِلَ لِتَعَارَفُوا",
          englishReference:
              "“O humanity! Indeed, We created you from a male and a female, and made you into peoples and tribes so that you may get to know one another.” (Surah Al-Hujurat 49:13)",
          actions: const [
            AiMessageAction(
              key: 'quran',
              label: "Qur'an Reader",
              route: 'quran',
              icon: Icons.menu_book_rounded,
            ),
            AiMessageAction(
              key: 'prophets',
              label: "Stories of Prophets",
              route: 'prophets',
              icon: Icons.history_edu_rounded,
            ),
          ],
        ),
      );
    } else {
      _messages.add(
        AiChatMessage(
          isUser: false,
          text:
              "السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ ٱللَّهِ وَبَرَكَاتُهُ$nameGreeting\n\nWelcome back! I am **MIA (My Islam AI)**, your personal Islamic companion.\n\nI know your daily streak, next prayer time, and the Islamic date. Ask me what to do right now, explore any question on the Holy Quran, Sunnah, Hadith, daily Fiqh & IslamQA rulings, or start a Heart-to-Heart session.",
          suggestedRoute: "home",
          suggestedRouteLabel: "Explore App Tour",
          arabicReference: "وَقُل رَّبِّ زِدْنِي عِلْمًا",
          englishReference: "“And say: My Lord, increase me in knowledge.” (Surah Taha 20:114)",
          actions: const [
            AiMessageAction(
              key: 'prayer',
              label: 'Prayer Times',
              route: 'prayer',
              icon: Icons.access_time_rounded,
            ),
            AiMessageAction(
              key: 'quran',
              label: "Qur'an Reader",
              route: 'quran',
              icon: Icons.menu_book_rounded,
            ),
            AiMessageAction(
              key: 'dua',
              label: 'Duas',
              route: 'duas',
              icon: Icons.favorite_rounded,
            ),
          ],
        ),
      );
    }
  }

  /// Interactive App Tour items
  static const List<AppFeatureGuideItem> appFeatures = [
    AppFeatureGuideItem(
      title: "The Holy Quran (Madani Mushaf)",
      subtitle: "Authentic 15-Line Hard Copy Layout",
      icon: "📖",
      route: "quran",
      description:
          "Experience the authentic 15-line Madani Mushaf standard printed by the King Fahd Complex with the calligraphy of Sheikh Uthman Taha. Includes natural right-to-left page turning across all 604 pages, pinch-to-zoom, and verse audio recitations.",
      highlights: [
        "100% exact printed King Fahd Complex plates",
        "RTL page swiping with book spine gutter depth",
        "Pinch-to-zoom for fine diacritics & tajweed",
        "Switch between Mushaf and Translation & Tafsir mode",
      ],
    ),
    AppFeatureGuideItem(
      title: "Prayer Times & Adhan",
      subtitle: "Accurate Timings & Live Countdown",
      icon: "🕋",
      route: "prayer",
      description:
          "Precision prayer schedules calculated from your location for Fajr, Sunrise, Dhuhr, Asr, Maghrib, and Isha with real-time countdown to the next prayer and authentic Makkah Adhan audio previews.",
      highlights: [
        "Automatic location-based calculation",
        "Dynamic time-of-day sky gradients",
        "Countdown to upcoming prayer",
        "Authentic Makkah Al-Mukarramah Adhan audio",
      ],
    ),
    AppFeatureGuideItem(
      title: "Digital Tasbih Counter",
      subtitle: "Tactile Dhikr with Lap Milestones",
      icon: "📿",
      route: "tasbih",
      description:
          "A modern digital prayer bead counter inspired by Muslim Pocket. Practice daily dhikr with spring animation feedback, customizable target loops (33, 99, 100, 1000), and lap celebrations.",
      highlights: [
        "Preset authentic dhikrs (SubhanAllah, Alhamdulillah, Allahu Akbar)",
        "Smooth tactile bead animation",
        "Milestone celebration & total counter",
        "Quick dhikr switcher with Arabic and translation",
      ],
    ),
    AppFeatureGuideItem(
      title: "Qiblah Compass",
      subtitle: "Precise Kaaba Direction Finder",
      icon: "🧭",
      route: "qiblah",
      description:
          "Find the exact direction towards the Holy Kaaba in Makkah Al-Mukarramah from anywhere on Earth using device sensors and spherical trigonometry calculations.",
      highlights: [
        "Real-time dynamic degree heading",
        "Exact distance to the Kaaba",
        "Visual Kaaba locator dial",
      ],
    ),
    AppFeatureGuideItem(
      title: "Duas & Azkar",
      subtitle: "Supplications from Quran & Sunnah",
      icon: "🤲",
      route: "duas",
      description:
          "Comprehensive collection of authentic Islamic supplications for morning & evening, hardship, seeking forgiveness, anxiety, travel, and daily life situations with Arabic, transliteration, and English meanings.",
      highlights: [
        "Categorized by everyday situations",
        "Full Arabic text with Harakat & audio",
        "Transliteration and Sahih translations",
        "One-tap copy and social share",
      ],
    ),
    AppFeatureGuideItem(
      title: "Zakat Calculator",
      subtitle: "Instant 2.5% Wealth Purification",
      icon: "💰",
      route: "zakat",
      description:
          "Calculate your mandatory Zakat with precision. Enter your gold, silver, cash, investments, and business assets, and let MyIslam determine your exact Nisab eligibility and payable Zakat.",
      highlights: [
        "Gold & Silver Nisab standards",
        "Cash, bank savings, and asset deduction",
        "Instant 2.5% payable calculation",
        "Direct Islamic charity integration",
      ],
    ),
    AppFeatureGuideItem(
      title: "Fasting & Ramadan Tracker",
      subtitle: "Suhoor, Iftar & Sawm Intentions",
      icon: "🌙",
      route: "fasting",
      description:
          "Keep track of obligatory Ramadan fasting and voluntary Sunnah fasts (Mondays & Thursdays, Ayyam al-Beed). Features live countdowns to Suhoor and Iftar with authentic fasting Duas.",
      highlights: [
        "Live Suhoor and Iftar countdown timers",
        "Fasting intention (Niyyah) & Iftar Duas",
        "Sunnah fasting calendar",
      ],
    ),
    AppFeatureGuideItem(
      title: "24/7 Live Quran Radio & Podcasts",
      subtitle: "Continuous Global Islamic Broadcasts",
      icon: "📻",
      route: "podcasts",
      description:
          "Listen to non-stop high-quality audio streams featuring world-renowned Qaris (Mishary Alafasy, Abdul Basit, Al-Sudais, Al-Shuraim, Al-Ghamdi) and inspiring Islamic lectures.",
      highlights: [
        "24/7 continuous recitation stream",
        "Background playback support with MiniPlayer",
        "Rich selection of legendary Qaris",
      ],
    ),
    AppFeatureGuideItem(
      title: "Islamic Hijri Calendar",
      subtitle: "Lunar Month Grid, White Days & Events",
      icon: "🗓️",
      route: "calendar",
      description:
          "Explore the complete Islamic lunar calendar with month-by-month grid, White Days (Ayyam al-Beed: 13th-15th) fasting indicators, Friday Jumu'ah highlights, holy milestones (Ramadan, Eid, Ashura, Arafah), and a two-way Gregorian ↔ Hijri date converter.",
      highlights: [
        "Full 12-month Hijri grid with Gregorian overlay",
        "White Days (Ayyam al-Beed) Sunnah fasting markers",
        "Upcoming sacred Islamic events with countdowns",
        "Interactive Gregorian to Hijri date converter",
      ],
    ),
    AppFeatureGuideItem(
      title: "Stories of the Prophets",
      subtitle: "25 Prophets Mentioned in the Quran",
      icon: "📜",
      route: "prophets",
      description:
          "Journey through the sacred biographies of all 25 Prophets of Allah, from Adam (AS) to the final Messenger Muhammad (ﷺ). Features verified Quranic verses, miraculous events (Mu'jizat), milestone timelines, moral lessons, and their authentic Quranic Duas.",
      highlights: [
        "All 25 Prophets documented in the Quran",
        "Chronological eras & historical locations",
        "Key Quranic Duas with Arabic, transliteration & English",
        "Divine miracles (Al-Mu'jizat) granted to each Prophet",
      ],
    ),
    AppFeatureGuideItem(
      title: "Hadith Explorer",
      subtitle: "40 Hadith Nawawi & Sahih Collections",
      icon: "📚",
      route: "hadith",
      description:
          "Read and study the complete 40 Hadith of Imam An-Nawawi (Al-Arba'in) along with authentic thematic Sahih collections covering faith, noble character (Akhlaq), family relationships, and repentance.",
      highlights: [
        "Complete 40 Hadith of Imam An-Nawawi",
        "Thematic Hadiths on Akhlaq, Family & Repentance",
        "Clear Arabic tashkeel with font size adjustment",
        "In-depth scholar commentary (Sharh) & authentic grading",
      ],
    ),
  ];

  Future<void> sendMessage(
    String userText, {
    int streak = 7,
    List<String> prayersCompleted = const [],
    int quranPages = 4,
    int duasRead = 12,
    String? nextPrayer,
    int? minutesToNextPrayer,
    String? hijriDate,
  }) async {
    final cleanInput = userText.trim();
    if (cleanInput.isEmpty) return;

    _messages.add(AiChatMessage(text: cleanInput, isUser: true));
    _isTyping = true;
    notifyListeners();

    // Natural brief delay for smooth interaction
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // 1. Heart-to-Heart Consultation mode check
      if (cleanInput.contains("[CONSULTATION MODE") ||
          cleanInput.contains("Heart-to-Heart") ||
          cleanInput.contains("What happened:") && cleanInput.contains("How I feel:")) {
        final consultReply = _generateConsultationReply(cleanInput);
        _messages.add(consultReply);
        return;
      }

      // 2. Proactive Prayer & Streak Companion Questions
      final companionMatch = _checkCompanionQueries(
        cleanInput,
        streak: streak,
        prayersCompleted: prayersCompleted,
        quranPages: quranPages,
        duasRead: duasRead,
        nextPrayer: nextPrayer,
        minutesToNextPrayer: minutesToNextPrayer,
        hijriDate: hijriDate,
      );
      if (companionMatch != null) {
        _messages.add(companionMatch);
        return;
      }

      // 3. Check verified Islamic Knowledge Repository (IslamQA + Interfaith)
      final repoMatch = IslamicKnowledgeRepository.findBestMatch(cleanInput, mode: _audienceMode);
      if (repoMatch != null) {
        final detectedActions = detectActions(repoMatch.englishText);
        _messages.add(
          AiChatMessage(
            isUser: false,
            text: repoMatch.englishText,
            arabicReference: repoMatch.arabicAyahOrHadith,
            englishReference: repoMatch.scholarlyReference,
            suggestedRoute: repoMatch.suggestedRoute,
            suggestedRouteLabel: repoMatch.suggestedRouteLabel,
            actions: detectedActions,
          ),
        );
        return;
      }

      // 4. Check if Gemini API is available
      if (_geminiApiKey != null && _geminiApiKey!.isNotEmpty) {
        final geminiReply = await _queryGemini(
          cleanInput,
          streak: streak,
          prayersCompleted: prayersCompleted,
          nextPrayer: nextPrayer,
          hijriDate: hijriDate,
        );
        if (geminiReply != null) {
          _messages.add(geminiReply);
          return;
        }
      }

      // 5. Smart Built-in Islamic Knowledge & Companion Engine
      final reply = _generateIntelligentIslamicReply(
        cleanInput,
        streak: streak,
        prayersCompleted: prayersCompleted,
        nextPrayer: nextPrayer,
      );
      _messages.add(reply);
    } catch (_) {
      _messages.add(
        AiChatMessage(
          isUser: false,
          text:
              "I apologize for the interruption. You can ask me about Quran, Duas, Prayer Times, Tasbih, or how to navigate the app!",
          actions: detectActions("prayer quran dua"),
        ),
      );
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  /// Detects interactive quick actions based on keywords in text
  static List<AiMessageAction> detectActions(String text) {
    final lower = text.toLowerCase();
    final List<AiMessageAction> actions = [];

    if (RegExp(r'\b(pray(er)?|salah|salat|adhan|fajr|dhuhr|zuhr|asr|maghrib|isha|jumu.?ah|wudu|rak.?ah)\b')
        .hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'prayer',
        label: 'Prayer Times',
        route: 'prayer',
        icon: Icons.access_time_rounded,
      ));
    }
    if (RegExp(r'\b(qur.?an|surah|ayah|ayat|recite|mushaf|tilawah|page)\b').hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'quran',
        label: "Qur'an Reader",
        route: 'quran',
        icon: Icons.menu_book_rounded,
      ));
    }
    if (RegExp(r'\b(du.?a|dua|adhkar|dhikr|supplication|remembrance|anxiety|peace|forgive)\b')
        .hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'dua',
        label: 'Duas & Azkar',
        route: 'duas',
        icon: Icons.favorite_rounded,
      ));
    }
    if (RegExp(r'\b(qibla|qiblah|kaaba|ka.?bah|direction|compass)\b').hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'qiblah',
        label: 'Qiblah Compass',
        route: 'qiblah',
        icon: Icons.explore_rounded,
      ));
    }
    if (RegExp(r'\b(fast(ing)?|sawm|suhoor|iftar|ramadan|white days|ayyam al-beed)\b').hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'fasting',
        label: 'Fasting Tracker',
        route: 'fasting',
        icon: Icons.nights_stay_rounded,
      ));
    }
    if (RegExp(r'\b(tasbih|tasbeeh|subhanallah|alhamdulillah|allahu akbar|counter|bead)\b')
        .hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'tasbih',
        label: 'Digital Tasbih',
        route: 'tasbih',
        icon: Icons.trip_origin_rounded,
      ));
    }
    if (RegExp(r'\b(zakat|zakah|charity|sadaqah|nisab)\b').hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'zakat',
        label: 'Zakat Calculator',
        route: 'zakat',
        icon: Icons.monetization_on_rounded,
      ));
    }
    if (RegExp(r'\b(calendar|hijri|sacred month|ashura|eid)\b').hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'calendar',
        label: 'Islamic Calendar',
        route: 'calendar',
        icon: Icons.calendar_month_rounded,
      ));
    }
    if (RegExp(r'\b(prophet|anbiya|messenger|adam|musa|isa|ibrahim)\b').hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'prophets',
        label: 'Stories of Prophets',
        route: 'prophets',
        icon: Icons.history_edu_rounded,
      ));
    }
    if (RegExp(r'\b(hadith|hadeeth|sunnah|nawawi|bukhari|muslim)\b').hasMatch(lower)) {
      actions.add(const AiMessageAction(
        key: 'hadith',
        label: 'Hadith Explorer',
        route: 'hadith',
        icon: Icons.library_books_rounded,
      ));
    }

    // Return at most 3 distinct actions to avoid cluttering
    return actions.take(3).toList();
  }

  /// Handles Companion Mode questions (streak, what to do right now, etc.)
  AiChatMessage? _checkCompanionQueries(
    String input, {
    required int streak,
    required List<String> prayersCompleted,
    required int quranPages,
    required int duasRead,
    String? nextPrayer,
    int? minutesToNextPrayer,
    String? hijriDate,
  }) {
    final lower = input.toLowerCase();

    // "What should I do right now?"
    if (lower.contains("what should i do right now") ||
        lower.contains("what should i do now") ||
        lower.contains("guide me right now") ||
        lower.contains("guide my day")) {
      final now = DateTime.now();
      final isFriday = now.weekday == DateTime.friday;
      final isMondayOrThursday = now.weekday == DateTime.monday || now.weekday == DateTime.thursday;

      final buffer = StringBuffer();
      buffer.writeln("Assalamu Alaikum! Here is your exact Islamic step right now:\n");

      if (isFriday) {
        buffer.writeln(
            "• **Blessed Jumu'ah**: Today is Friday! It is highly rewarding to recite Surah Al-Kahf, send abundant Salawat upon the Prophet ﷺ, and make Dua in the blessed hour before Maghrib.");
      } else if (isMondayOrThursday) {
        buffer.writeln(
            "• **Sunnah Day**: Today is a Sunnah fasting day observed by Prophet Muhammad ﷺ. If you are fasting, may Allah accept your devotion!");
      }

      if (nextPrayer != null && minutesToNextPrayer != null) {
        if (minutesToNextPrayer <= 45) {
          buffer.writeln(
              "• **Upcoming Salah**: **$nextPrayer** is in ~$minutesToNextPrayer minutes. Prepare your Wudu calmly, quiet your mind, and get ready to stand before Allah.");
        } else {
          buffer.writeln(
              "• **Next Prayer**: **$nextPrayer** is in ~$minutesToNextPrayer minutes. You have time for a virtuous deed!");
        }
      }

      buffer.writeln(
          "• **Your Streak**: MashaAllah, you're on a **$streak-day streak** with ${prayersCompleted.length}/5 prayers marked today.");
      buffer.writeln(
          "\n**One Action Right Now**: Recite 33 times `سُبْحَانَ ٱللَّهِ وَبِحَمْدِهِ` (SubhanAllahi wa bihamdihi) or read 1 page of the Holy Quran.");

      return AiChatMessage(
        isUser: false,
        text: buffer.toString(),
        suggestedRoute: "prayer",
        suggestedRouteLabel: "Check Prayer Times",
        actions: const [
          AiMessageAction(
            key: 'prayer',
            label: 'Prayer Times',
            route: 'prayer',
            icon: Icons.access_time_rounded,
          ),
          AiMessageAction(
            key: 'quran',
            label: "Qur'an Reader",
            route: 'quran',
            icon: Icons.menu_book_rounded,
          ),
          AiMessageAction(
            key: 'tasbih',
            label: 'Digital Tasbih',
            route: 'tasbih',
            icon: Icons.trip_origin_rounded,
          ),
        ],
      );
    }

    // "How's my streak — what's my next step?"
    if (lower.contains("streak") || lower.contains("my progress")) {
      return AiChatMessage(
        isUser: false,
        text:
            "MashaAllah! You have maintained an active streak of **$streak days** of connecting with Allah!\n\n"
            "The Prophet Muhammad ﷺ said: *'The most beloved of deeds to Allah are those that are most consistent, even if they are small.'* (Sahih al-Bukhari 6464).\n\n"
            "• Prayers logged today: **${prayersCompleted.length}/5**\n"
            "• Quran pages read: **$quranPages**\n"
            "• Duas recited: **$duasRead**\n\n"
            "**Your Next Step**: Keep your intention sincere, pray your upcoming Salah with Khushu', and recite your morning or evening Adhkar.",
        suggestedRoute: "progress",
        suggestedRouteLabel: "View Full Progress",
        actions: const [
          AiMessageAction(
            key: 'prayer',
            label: 'Prayer Times',
            route: 'prayer',
            icon: Icons.access_time_rounded,
          ),
          AiMessageAction(
            key: 'dua',
            label: 'Duas',
            route: 'duas',
            icon: Icons.favorite_rounded,
          ),
        ],
      );
    }

    // "What's special about today?"
    if (lower.contains("special about today") || lower.contains("what is today")) {
      final now = DateTime.now();
      String weekdayVirtue = "";
      if (now.weekday == DateTime.friday) {
        weekdayVirtue =
            "Today is **Jumu'ah (Friday)**, the best day upon which the sun rises! The Prophet ﷺ said: *'The best day on which the sun has risen is Friday; on it Adam was created, on it he was admitted to Paradise, and on it he was taken out of it.'* (Sahih Muslim 854).";
      } else if (now.weekday == DateTime.monday || now.weekday == DateTime.thursday) {
        weekdayVirtue =
            "Today is **${now.weekday == DateTime.monday ? 'Monday' : 'Thursday'}**, a day when deeds are presented to Allah. The Prophet ﷺ said: *'Deeds are shown (to Allah) on Mondays and Thursdays, and I like my deeds to be shown while I am fasting.'* (Jami` at-Tirmidhi 747).";
      } else {
        weekdayVirtue =
            "Every day given to a believer is an invaluable gift and opportunity to earn eternal reward, seek forgiveness, and draw closer to Allah!";
      }

      return AiChatMessage(
        isUser: false,
        text:
            "$weekdayVirtue\n\nTake advantage of today by reciting Ayat al-Kursi, sending blessings upon the Prophet ﷺ, and making sincere Dua.",
        suggestedRoute: "calendar",
        suggestedRouteLabel: "Open Islamic Calendar",
        actions: const [
          AiMessageAction(
            key: 'calendar',
            label: 'Islamic Calendar',
            route: 'calendar',
            icon: Icons.calendar_month_rounded,
          ),
          AiMessageAction(
            key: 'quran',
            label: "Qur'an Reader",
            route: 'quran',
            icon: Icons.menu_book_rounded,
          ),
        ],
      );
    }

    // "Suggest an adhkar for now"
    if (lower.contains("suggest an adhkar") ||
        lower.contains("adhkar for now") ||
        lower.contains("dhikr for now") ||
        lower.contains("what dhikr")) {
      return AiChatMessage(
        isUser: false,
        text:
            "Here is a powerful, beloved Dhikr to recite right now:\n\n"
            "**سُبْحَانَ ٱللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ ٱللَّهِ ٱلْعَظِيمِ**\n"
            "*“SubhanAllahi wa bihamdihi, SubhanAllahil 'Azeem”*\n\n"
            "The Prophet ﷺ said: *'Two words are light on the tongue, heavy in the scales, and beloved to the Most Merciful: SubhanAllahi wa bihamdihi, SubhanAllahil 'Azeem.'* (Sahih al-Bukhari 6406).\n\n"
            "Tap below to practice it on our Digital Tasbih counter!",
        suggestedRoute: "tasbih",
        suggestedRouteLabel: "Open Digital Tasbih",
        arabicReference: "كَلِمَتَانِ خَفِيفَتَانِ عَلَى اللِّسَانِ ثَقِيلَتَانِ فِي الْمِيزَانِ",
        englishReference: "“Two words are light on the tongue, heavy in the scales...” (Bukhari 6406)",
        actions: const [
          AiMessageAction(
            key: 'tasbih',
            label: 'Digital Tasbih',
            route: 'tasbih',
            icon: Icons.trip_origin_rounded,
          ),
          AiMessageAction(
            key: 'dua',
            label: 'Browse Duas',
            route: 'duas',
            icon: Icons.favorite_rounded,
          ),
        ],
      );
    }

    return null;
  }

  /// Generates Heart-to-Heart Consultation Mode response
  AiChatMessage _generateConsultationReply(String input) {
    return AiChatMessage(
      isUser: false,
      text:
          "### 💜 I hear you\n"
          "Take a slow, gentle breath. Facing moments of stress, sadness, or overwhelming burden is deeply human, and your feelings are completely valid. You do not have to carry everything alone. Allah sees your silent tears, hears the whispers of your heart, and has never abandoned you.\n\n"
          "### 📖 Islamic Perspective\n"
          "Hold firmly to the reassuring promise of your Creator in the Holy Quran:\n"
          "*“Allah does not burden a soul beyond that it can bear.”* (Surah Al-Baqarah 2:286)\n"
          "And His divine pledge:\n"
          "*“Indeed, with hardship comes ease.”* (Surah Ash-Sharh 94:6)\n\n"
          "The Messenger of Allah ﷺ said:\n"
          "*“No fatigue, nor disease, nor sorrow, nor sadness, nor hurt, nor distress befalls a Muslim, even if it were the prick of a thorn, but that Allah expiates some of his sins for that.”* (Sahih al-Bukhari 5641).\n\n"
          "### 🤲 A Dua for You\n"
          "**اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ**\n"
          "*“Allahumma inni a'udhu bika minal-hammi wal-hazan, wal-'ajzi wal-kasal...”*\n"
          "“O Allah, I seek refuge in You from grief and sadness, weakness and laziness, miserliness and cowardice, the burden of debts and being overpowered.” (Bukhari 2893)\n\n"
          "### ✅ 3 Steps You Can Take Today\n"
          "1. **Perform a calm, mindful Wudu** and pray 2 Rak'ahs of Salah with your heart resting in peaceful Sujood.\n"
          "2. **Pour your heart out in private Dua** — speak to Allah freely in your own native words. He is closer to you than your jugular vein.\n"
          "3. **Recite 33 times Istighfar** (`Astaghfirullah`) and send blessings on Prophet Muhammad ﷺ. Let peace settle in your chest.",
      suggestedRoute: "duas",
      suggestedRouteLabel: "Open Duas for Anxiety",
      arabicReference: "أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ",
      englishReference: "“Unquestionably, by the remembrance of Allah hearts are assured.” (Surah Ar-Ra'd 13:28)",
      actions: const [
        AiMessageAction(
          key: 'dua',
          label: 'Duas for Distress',
          route: 'duas',
          icon: Icons.favorite_rounded,
        ),
        AiMessageAction(
          key: 'prayer',
          label: 'Prayer Guide',
          route: 'prayer',
          icon: Icons.access_time_rounded,
        ),
        AiMessageAction(
          key: 'tasbih',
          label: 'Digital Tasbih',
          route: 'tasbih',
          icon: Icons.trip_origin_rounded,
        ),
      ],
    );
  }

  Future<AiChatMessage?> _queryGemini(
    String prompt, {
    int streak = 7,
    List<String> prayersCompleted = const [],
    String? nextPrayer,
    String? hijriDate,
  }) async {
    try {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey",
      );

      final systemPrompt = """You are MIA (My Islam AI), a warm, personal Islamic companion for the user of the MyIslam app.

CURRENT USER CONTEXT:
- Name: ${_userName ?? "User"}
- Current Streak: $streak days
- Prayers Completed Today: ${prayersCompleted.join(', ')}
- Next Prayer: ${nextPrayer ?? "Upcoming"}
- Islamic Hijri Date: ${hijriDate ?? "Islamic Lunar Month"}

You have two modes:
1. COMPANION MODE (default for greetings, advice, day/streak):
- Greet with "Assalamu alaikum", be concise, warm, and personal.
- Anchor advice to the current Islamic moment, streak, and next prayer.
- Keep answers 3-7 lines, warm, action-first.

2. KNOWLEDGE MODE (when asked fiqh, tafsir, hadith, or rulings):
- Answer accurately using Qur'an, authentic Sunnah (Sahih Bukhari, Sahih Muslim), and verified scholarship (IslamQA).
- Format: Short Direct Answer, Evidence, Practical Guidance, and Sources.

Never invent hadith. Truth over popularity. Always keep the user connected to Allah.""";

      final body = json.encode({
        "contents": [
          {
            "parts": [
              {
                "text": "$systemPrompt\n\nUser Question: $prompt",
              }
            ]
          }
        ]
      });

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'] as String?;
            if (text != null && text.isNotEmpty) {
              final cleanText = text.trim();
              return AiChatMessage(
                isUser: false,
                text: cleanText,
                suggestedRoute: _detectRoute(cleanText),
                suggestedRouteLabel: _getRouteLabel(_detectRoute(cleanText)),
                actions: detectActions(cleanText),
              );
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  AiChatMessage _generateIntelligentIslamicReply(
    String input, {
    int streak = 7,
    List<String> prayersCompleted = const [],
    String? nextPrayer,
  }) {
    final lower = input.toLowerCase();

    // 1. App Tour / Help / Features
    if (lower.contains("tour") ||
        lower.contains("guide") ||
        lower.contains("how to use") ||
        lower.contains("what can you do") ||
        lower.contains("features") ||
        lower.contains("app")) {
      return AiChatMessage(
        isUser: false,
        text:
            "**MyIslam** is your comprehensive, all-in-one Islamic spiritual companion!\n\nHere is what you can do right in the app:\n\n"
            "• 📖 **Holy Quran**: Read the authentic 15-line King Fahd Madani Mushaf with natural RTL page flipping, pinch-to-zoom, and verse recitations.\n"
            "• 🕋 **Prayer Times & Adhan**: Real-time accurate prayer times, next prayer countdown, and Makkah Adhan audio.\n"
            "• 📿 **Digital Tasbih**: Animated tactile dhikr bead counter with preset Adhkar and progress loops.\n"
            "• 🧭 **Qiblah Compass**: Instant accurate direction towards the Kaaba.\n"
            "• 🤲 **Duas & Hadiths**: Authentic daily supplications and Prophet's sayings.\n"
            "• 💰 **Zakat Calculator**: Calculate your 2.5% wealth purification easily.\n"
            "• 🌙 **Fasting Tracker**: Suhoor & Iftar times with fasting intentions.\n"
            "• 📻 **Live Quran Radio**: 24/7 recitations from legendary Qaris.\n\n"
            "Tap any shortcut below or ask me any question!",
        suggestedRoute: "home",
        suggestedRouteLabel: "Open App Home",
        actions: detectActions("quran prayer tasbih dua"),
      );
    }

    // 2. Islamic Calendar / Hijri Date inquiries
    if (lower.contains("calendar") ||
        lower.contains("hijri") ||
        lower.contains("white day") ||
        lower.contains("ayyam al-beed") ||
        lower.contains("ayyam al beed") ||
        lower.contains("islamic date") ||
        lower.contains("sacred month") ||
        lower.contains("ashura") ||
        lower.contains("mawlid")) {
      return AiChatMessage(
        isUser: false,
        text:
            "The **Islamic Hijri Calendar** is a sacred lunar calendar of 12 months decreed by Allah in the Holy Quran (Surah At-Tawbah 9:36).\n\n"
            "Key virtues & dates:\n"
            "• **White Days (Ayyam al-Beed)**: 13th, 14th, and 15th of every lunar month. Fasting them is like fasting a lifetime (Sahih al-Bukhari 1975).\n"
            "• **Sacred Months (الأشهر الحرم)**: Dhul Qi'dah, Dhul Hijjah, Muharram, and Rajab.\n"
            "• **Milestones**: Ramadan, Eid al-Fitr, Day of Arafah, Eid al-Adha, and Ashura.\n\n"
            "Tap below to open our interactive Month Grid and two-way date converter!",
        suggestedRoute: "calendar",
        suggestedRouteLabel: "Open Islamic Calendar",
        arabicReference: "إِنَّ عِدَّةَ الشُّهُورِ عِندَ اللَّهِ اثْنَا عَشَرَ شَهْرًا فِي كِتَابِ اللَّهِ",
        englishReference:
            "“Indeed, the number of months with Allah is twelve [lunar] months in the register of Allah.” (Surah At-Tawbah 9:36)",
        actions: detectActions("calendar fasting"),
      );
    }

    // 3. Quran / Mushaf / Surah inquiries
    if (lower.contains("quran") ||
        lower.contains("mushaf") ||
        lower.contains("surah") ||
        lower.contains("ayah") ||
        lower.contains("page") ||
        lower.contains("yaseen") ||
        lower.contains("mulk") ||
        lower.contains("kahf") ||
        lower.contains("baqarah") ||
        lower.contains("fatiha")) {
      String specific = "";
      if (lower.contains("mulk")) {
        specific =
            "\n\n**Surah Al-Mulk (67)**: The Prophet ﷺ said: *'There is a surah of thirty verses which intercedes for a person until he is forgiven: Tabarak alladhi bi yadihi'l-mulk.'* (Abu Dawood 1400). It is highly recommended to recite every night before sleep!";
      } else if (lower.contains("kahf")) {
        specific =
            "\n\n**Surah Al-Kahf (18)**: Reciting Surah Al-Kahf on Friday illuminates the believer with light from one Friday to the next (Sunan al-Bayhaqi).";
      } else if (lower.contains("yaseen")) {
        specific =
            "\n\n**Surah Yaseen (36)**: Known as the heart of the Quran, filled with deep reminders of creation, resurrection, and Allah's mercy.";
      }

      return AiChatMessage(
        isUser: false,
        text:
            "Our Quran reader gives you the **authentic 15-line Madani Mushaf** published by the King Fahd Complex in Medina with Sheikh Uthman Taha's calligraphy!$specific\n\nYou can flip pages by swiping right-to-left, pinch to zoom into the tashkeel, listen to recitation by Sheikh Mishary Alafasy, or switch to the translation mode anytime.",
        suggestedRoute: "quran",
        suggestedRouteLabel: "Open Holy Quran",
        arabicReference: "إِنَّ هَٰذَا ٱلْقُرْءَانَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ",
        englishReference: "“Indeed, this Quran guides to that which is most suitable.” (Surah Al-Isra 17:9)",
        actions: detectActions("quran"),
      );
    }

    // 4. Stories of the Prophets (Qisas al-Anbiya)
    if (lower.contains("prophet") ||
        lower.contains("anbiya") ||
        lower.contains("messenger") ||
        lower.contains("adam") ||
        lower.contains("nuh") ||
        lower.contains("noah") ||
        lower.contains("ibrahim") ||
        lower.contains("abraham") ||
        lower.contains("musa") ||
        lower.contains("moses") ||
        lower.contains("isa") ||
        lower.contains("jesus") ||
        lower.contains("yunus") ||
        lower.contains("jonah") ||
        lower.contains("yusuf") ||
        lower.contains("joseph") ||
        lower.contains("sulaiman") ||
        lower.contains("solomon") ||
        lower.contains("dawood") ||
        lower.contains("david") ||
        lower.contains("ayyub") ||
        lower.contains("job") ||
        lower.contains("miracle")) {
      return AiChatMessage(
        isUser: false,
        text:
            "The Quran documents the sacred lives of **25 noble Prophets of Allah**, from Adam (AS) to the seal of the Prophets Muhammad (ﷺ).\n\n"
            "Each Prophet exemplified supreme patience (Sabr), unwavering trust in Allah (Tawakkul), and delivered the timeless message of Tawhid.\n\n"
            "In MyIslam, you can explore the complete chronicles of all 25 Prophets—including their historical eras, divine miracles (*Al-Mu'jizat*), life milestones, and the authentic Quranic Duas they supplicated during their moments of trial.\n\n"
            "Tap below to open **Stories of the Prophets**!",
        suggestedRoute: "prophets",
        suggestedRouteLabel: "Explore 25 Prophets",
        arabicReference: "وَرُسُلًا قَدْ قَصَصْنَاهُمْ عَلَيْكَ مِن قَبْلُ",
        englishReference:
            "“And [We sent] messengers about whom We have related [their stories] to you before...” (Surah An-Nisa 4:164)",
        actions: detectActions("prophets quran"),
      );
    }

    // 5. Hadith & Sunnah inquiries
    if (lower.contains("hadith") ||
        lower.contains("hadeeth") ||
        lower.contains("sunnah") ||
        lower.contains("nawawi") ||
        lower.contains("bukhari") ||
        lower.contains("muslim") ||
        lower.contains("saying of the prophet") ||
        lower.contains("saying of prophet") ||
        lower.contains("40 hadith") ||
        lower.contains("forty hadith")) {
      return AiChatMessage(
        isUser: false,
        text:
            "The **Hadith** represents the authentic words, actions, approvals, and noble character of the Prophet Muhammad ﷺ, serving as the second primary source of Islamic guidance alongside the Holy Quran.\n\n"
            "In MyIslam's **Hadith Explorer**, you can study:\n"
            "• **The Renowned 40 Hadith of Imam An-Nawawi** (Al-Arba'in An-Nawawiyyah), universally celebrated as the pillars of Islamic wisdom.\n"
            "• **Thematic Sahih Collections** on Faith & Sincerity, Noble Akhlaq, Kindness to Parents & Family, and Sincere Repentance.\n"
            "• Clear Arabic tashkeel with font resizer, translations, and scholar commentaries (*Sharh*).\n\n"
            "Tap below to begin exploring!",
        suggestedRoute: "hadith",
        suggestedRouteLabel: "Open Hadith Explorer",
        arabicReference: "مَّن يُطِعِ الرَّسُولَ فَقَدْ أَطَاعَ اللَّهَ",
        englishReference: "“He who obeys the Messenger has indeed obeyed Allah.” (Surah An-Nisa 4:80)",
        actions: detectActions("hadith"),
      );
    }

    // 6. Tasbih / Dhikr inquiries
    if (lower.contains("tasbih") ||
        lower.contains("tasbeeh") ||
        lower.contains("dhikr") ||
        lower.contains("subhanallah") ||
        lower.contains("alhamdulillah") ||
        lower.contains("allahu akbar") ||
        lower.contains("istighfar") ||
        lower.contains("bead") ||
        lower.contains("counter")) {
      return AiChatMessage(
        isUser: false,
        text:
            "Remembering Allah (Dhikr) brings deep tranquility to the heart.\n\n**Recommended Daily Dhikr**:\n• `سُبْحَانَ ٱللَّهِ` (SubhanAllah) — 33 times\n• `ٱلْحَمْدُ لِلَّهِ` (Alhamdulillah) — 33 times\n• `ٱللَّهُ أَكْبَرُ` (Allahu Akbar) — 34 times\n• `أَسْتَغْفِرُ ٱللَّهَ` (Astaghfirullah) — 100 times daily\n\nYou can track all your Adhkar seamlessly using the interactive **Digital Tasbih** in MyIslam with tactile bead animations and milestone celebrations!",
        suggestedRoute: "tasbih",
        suggestedRouteLabel: "Open Digital Tasbih",
        arabicReference: "أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ",
        englishReference:
            "“Unquestionably, by the remembrance of Allah hearts are assured.” (Surah Ar-Ra'd 13:28)",
        actions: detectActions("tasbih dua"),
      );
    }

    // 7. Prayer / Salah / Adhan inquiries
    if (lower.contains("prayer") ||
        lower.contains("salah") ||
        lower.contains("salat") ||
        lower.contains("namaz") ||
        lower.contains("adhan") ||
        lower.contains("fajr") ||
        lower.contains("dhuhr") ||
        lower.contains("asr") ||
        lower.contains("maghrib") ||
        lower.contains("isha") ||
        lower.contains("wudu") ||
        lower.contains("tahajjud")) {
      return AiChatMessage(
        isUser: false,
        text:
            "Salah is the second pillar of Islam and the direct spiritual conversation between you and Allah (SWT).\n\n"
            "• **The 5 Daily Prayers**: Fajr (Dawn), Dhuhr (Noon), Asr (Afternoon), Maghrib (Sunset), and Isha (Night).\n"
            "• **Tahajjud**: The night prayer prayed in the last third of the night before Fajr—a time when prayers are directly answered.\n\n"
            "Check today's exact prayer schedule and listen to the Adhan from Makkah in the **Prayer Times** screen!",
        suggestedRoute: "prayer",
        suggestedRouteLabel: "View Prayer Times",
        arabicReference: "إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَٰبًا مَّوْقُوتًا",
        englishReference:
            "“Indeed, prayer has been decreed upon the believers a decree of specified times.” (Surah An-Nisa 4:103)",
        actions: detectActions("prayer qiblah"),
      );
    }

    // 8. Qiblah direction inquiries
    if (lower.contains("qiblah") ||
        lower.contains("qibla") ||
        lower.contains("kaaba") ||
        lower.contains("direction") ||
        lower.contains("compass") ||
        lower.contains("makkah")) {
      return AiChatMessage(
        isUser: false,
        text:
            "The Qiblah is the direction towards the sacred Kaaba at Al-Masjid Al-Haram in Makkah Al-Mukarramah.\n\n"
            "To use the **Qiblah Compass**:\n1. Hold your device flat in the palm of your hand.\n2. Calibrate by gently rotating the device in a figure-8 motion if requested.\n3. Turn your body until the needle aligns directly with the golden Kaaba emblem!",
        suggestedRoute: "qiblah",
        suggestedRouteLabel: "Open Qiblah Compass",
        arabicReference: "فَوَلِّ وَجْهَكَ شَطْرَ ٱلْمَسْجِدِ ٱلْحَرَامِ",
        englishReference: "“So turn your face toward al-Masjid al-Haram...” (Surah Al-Baqarah 2:144)",
        actions: detectActions("qiblah prayer"),
      );
    }

    // 9. Duas / Supplications / Anxiety / Sadness / Protection
    if (lower.contains("dua") ||
        lower.contains("anxiety") ||
        lower.contains("stress") ||
        lower.contains("sad") ||
        lower.contains("depressed") ||
        lower.contains("protect") ||
        lower.contains("evil eye") ||
        lower.contains("sick") ||
        lower.contains("illness") ||
        lower.contains("forgive") ||
        lower.contains("rizq") ||
        lower.contains("wealth")) {
      String specificDua = "";
      if (lower.contains("anxiety") || lower.contains("stress") || lower.contains("sad")) {
        specificDua =
            "\n\n**Dua for Relief from Distress**:\n`اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ`\n*“O Allah, I seek refuge in You from grief and sadness, weakness and laziness, miserliness and cowardice, the burden of debts and being overpowered by men.”* (Sahih al-Bukhari 2893)";
      } else if (lower.contains("forgive")) {
        specificDua =
            "\n\n**Sayyid al-Istighfar (Master of Forgiveness)**:\n`اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ...`\nWhoever recites this with conviction in the evening and dies that night will enter Paradise (Bukhari).";
      }

      return AiChatMessage(
        isUser: false,
        text:
            "Dua is the weapon of the believer and the core of worship! Allah loves when His servants ask Him.$specificDua\n\nExplore our categorized library of authentic Duas with Arabic text, transliteration, and English audio in the **Duas section**.",
        suggestedRoute: "duas",
        suggestedRouteLabel: "Browse All Duas",
        arabicReference: "وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ ٱلدَّاعِ إِذَا دَعَانِ",
        englishReference:
            "“And when My servants ask you concerning Me, indeed I am near. I respond to the invocation of the supplicant when he calls upon Me.” (Surah Al-Baqarah 2:186)",
        actions: detectActions("dua tasbih"),
      );
    }

    // 10. Fasting / Ramadan / Suhoor / Iftar inquiries
    if (lower.contains("fast") ||
        lower.contains("sawm") ||
        lower.contains("ramadan") ||
        lower.contains("suhoor") ||
        lower.contains("sehri") ||
        lower.contains("iftar")) {
      return AiChatMessage(
        isUser: false,
        text:
            "Fasting (Sawm) teaches Taqwa (God-consciousness), self-restraint, and compassion for those in need.\n\n"
            "• **Suhoor**: The pre-dawn meal before Fajr. The Prophet ﷺ said: *'Eat Suhoor, for in Suhoor there is blessing.'* (Bukhari & Muslim).\n"
            "• **Iftar Dua**: `ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ` (*'The thirst is gone, the veins are moistened, and the reward is confirmed, if Allah wills.'*)\n\n"
            "Check live countdowns to Suhoor and Iftar in our **Fasting Tracker**!",
        suggestedRoute: "fasting",
        suggestedRouteLabel: "Open Fasting Tracker",
        arabicReference: "كُتِبَ عَلَيْكُمُ ٱلصِّيَامُ كَمَا كُتِبَ عَلَى ٱلَّذِينَ مِن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ",
        englishReference:
            "“Fasting is prescribed for you as it was prescribed for those before you, that you may attain Taqwa.” (Surah Al-Baqarah 2:183)",
        actions: detectActions("fasting calendar"),
      );
    }

    // 11. Zakat / Sadaqah / Charity inquiries
    if (lower.contains("zakat") ||
        lower.contains("zakah") ||
        lower.contains("charity") ||
        lower.contains("sadaqah") ||
        lower.contains("nisab")) {
      return AiChatMessage(
        isUser: false,
        text:
            "Zakat is the third pillar of Islam and purifies your accumulated wealth.\n\n"
            "• **Eligibility (Nisab)**: Wealth held for one full lunar year (Hawl) above the threshold (85 grams of gold or 595 grams of silver).\n"
            "• **Rate**: **2.5%** on net qualifying assets (cash, savings, gold/silver, investment shares, and trade merchandise).\n\n"
            "Use our built-in **Zakat Calculator** to instantly calculate your precise due Zakat and donate directly!",
        suggestedRoute: "zakat",
        suggestedRouteLabel: "Calculate Zakat",
        arabicReference: "خُذْ مِنْ أَمْوَٰلِهِمْ صَدَقَةً تُطَهِّرُهُمْ وَتُزَكِّيهِم بِهَا",
        englishReference:
            "“Take from their wealth a charity by which you purify them and cause them increase...” (Surah At-Tawbah 9:103)",
        actions: detectActions("zakat"),
      );
    }

    // 12. Audio / Radio / Podcast inquiries
    if (lower.contains("radio") ||
        lower.contains("podcast") ||
        lower.contains("listen") ||
        lower.contains("audio") ||
        lower.contains("qari") ||
        lower.contains("reciter")) {
      return AiChatMessage(
        isUser: false,
        text:
            "Immerse your home and heart in the beauty of the Quran with **MyIslam Live Radio**!\n\nWe stream 24/7 continuous recitation from world-famous Qaris, including Mishary Rashid Alafasy, Abdul Basit Abdul Samad, Saad Al-Ghamdi, and Abdur-Rahman As-Sudais, with background listening support.",
        suggestedRoute: "podcasts",
        suggestedRouteLabel: "Listen to Live Radio",
        actions: const [
          AiMessageAction(
            key: 'radio',
            label: 'Listen to Radio',
            route: 'podcasts',
            icon: Icons.radio_rounded,
          ),
          AiMessageAction(
            key: 'quran',
            label: "Qur'an Reader",
            route: 'quran',
            icon: Icons.menu_book_rounded,
          ),
        ],
      );
    }

    // Default friendly companion response
    return AiChatMessage(
      isUser: false,
      text:
          "Thank you for reaching out! In Islam, seeking beneficial knowledge (*'Ilm*) is an act of worship.\n\n"
          "You can ask me about:\n"
          "• Holy Quran verses and Surah benefits\n"
          "• Recommended Duas and Azkar for peace of mind\n"
          "• Prayer times, Wudu, and Qiblah direction\n"
          "• Digital Tasbih counting and Dhikr rewards\n"
          "• Fasting rules, Suhoor & Iftar times\n"
          "• Or start a private Heart-to-Heart session!\n\n"
          "How can I assist your spiritual journey today?",
      suggestedRoute: "home",
      suggestedRouteLabel: "Explore Features",
      actions: detectActions("prayer quran dua"),
    );
  }

  String? _detectRoute(String input) {
    final lower = input.toLowerCase();
    if (lower.contains("quran") || lower.contains("mushaf") || lower.contains("surah")) return "quran";
    if (lower.contains("tasbih") || lower.contains("dhikr") || lower.contains("bead")) return "tasbih";
    if (lower.contains("prayer") || lower.contains("salah") || lower.contains("adhan")) return "prayer";
    if (lower.contains("qiblah") || lower.contains("kaaba")) return "qiblah";
    if (lower.contains("dua") || lower.contains("azkar")) return "duas";
    if (lower.contains("zakat") || lower.contains("nisab")) return "zakat";
    if (lower.contains("fast") || lower.contains("ramadan")) return "fasting";
    if (lower.contains("radio") || lower.contains("podcast")) return "podcasts";
    if (lower.contains("prophet") || lower.contains("anbiya")) return "prophets";
    if (lower.contains("hadith") || lower.contains("nawawi")) return "hadith";
    if (lower.contains("calendar") || lower.contains("hijri")) return "calendar";
    return null;
  }

  String _getRouteLabel(String? route) {
    switch (route) {
      case "quran":
        return "Open Holy Quran";
      case "tasbih":
        return "Open Digital Tasbih";
      case "prayer":
        return "View Prayer Times";
      case "qiblah":
        return "Open Qiblah Finder";
      case "duas":
        return "Browse Duas";
      case "zakat":
        return "Calculate Zakat";
      case "fasting":
        return "Open Fasting Tracker";
      case "podcasts":
        return "Listen to Radio";
      case "prophets":
        return "Explore Prophets";
      case "hadith":
        return "Hadith Explorer";
      case "calendar":
        return "Islamic Calendar";
      default:
        return "View in App";
    }
  }
}
