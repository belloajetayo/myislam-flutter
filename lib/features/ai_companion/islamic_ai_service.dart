import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? suggestedRoute;
  final String? suggestedRouteLabel;
  final String? arabicReference;
  final String? englishReference;

  AiChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.suggestedRoute,
    this.suggestedRouteLabel,
    this.arabicReference,
    this.englishReference,
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

  List<AiChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  IslamicAiService() {
    _initWelcome();
  }

  void setApiKey(String? key) {
    _geminiApiKey = key;
  }

  void _initWelcome() {
    _messages.add(
      AiChatMessage(
        isUser: false,
        text:
            "السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ ٱللَّهِ وَبَرَكَاتُهُ\n\nWelcome! I am **MyIslam AI**, your personal Islamic companion and interactive guide to the app.\n\nAsk me any question about the Holy Quran, Hadith, daily prayers, fasting, duas, or tap below to explore any feature in MyIslam!",
        suggestedRoute: "home",
        suggestedRouteLabel: "Explore App Tour",
        arabicReference: "وَقُل رَّبِّ زِدْنِي عِلْمًا",
        englishReference: "“And say: My Lord, increase me in knowledge.” (Surah Taha 20:114)",
      ),
    );
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
  ];

  Future<void> sendMessage(String userText) async {
    final cleanInput = userText.trim();
    if (cleanInput.isEmpty) return;

    _messages.add(AiChatMessage(text: cleanInput, isUser: true));
    _isTyping = true;
    notifyListeners();

    // Artificial brief delay for realistic conversational feel
    await Future.delayed(const Duration(milliseconds: 650));

    try {
      // 1. Check if Gemini API key is configured and can be queried
      if (_geminiApiKey != null && _geminiApiKey!.isNotEmpty) {
        final geminiReply = await _queryGemini(cleanInput);
        if (geminiReply != null) {
          _messages.add(geminiReply);
          _isTyping = false;
          notifyListeners();
          return;
        }
      }

      // 2. Intelligent Built-in Islamic Knowledge & Guide Engine
      final reply = _generateIntelligentIslamicReply(cleanInput);
      _messages.add(reply);
    } catch (_) {
      _messages.add(
        AiChatMessage(
          isUser: false,
          text:
              "I apologize for the interruption. You can ask me about Quran, Duas, Prayer Times, Tasbih, or how to navigate the app!",
        ),
      );
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  Future<AiChatMessage?> _queryGemini(String prompt) async {
    try {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey",
      );
      final body = json.encode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "You are MyIslam AI, a polite, respectful, and authentic Islamic AI guide and app companion. Answer the user's question clearly, warmly, and grounded in the Holy Quran and authentic Sunnah. When appropriate, provide Arabic verses or Hadith references with English translations.\n\nUser Question: $prompt",
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
              return AiChatMessage(
                isUser: false,
                text: text.trim(),
                suggestedRoute: _detectRoute(prompt),
                suggestedRouteLabel: _getRouteLabel(_detectRoute(prompt)),
              );
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  AiChatMessage _generateIntelligentIslamicReply(String input) {
    final lower = input.toLowerCase();

    // 1. App Tour / Help / How does this app work
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
            "Tap any of the quick shortcuts or ask me where you'd like to go!",
        suggestedRoute: "home",
        suggestedRouteLabel: "Open App Home",
      );
    }

    // 2. Quran / Mushaf / Surah inquiries
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
            "\n\n**Surah Al-Mulk (67)**: The Prophet (ﷺ) said: *'There is a surah of thirty verses which intercedes for a person until he is forgiven: Tabarak alladhi bi yadihi'l-mulk.'* (Abu Dawood 1400). It is highly recommended to recite every night before sleep!";
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
      );
    }

    // 3. Tasbih / Dhikr inquiries
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
        englishReference: "“Unquestionably, by the remembrance of Allah hearts are assured.” (Surah Ar-Ra'd 13:28)",
      );
    }

    // 4. Prayer / Salah / Adhan inquiries
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
        englishReference: "“Indeed, prayer has been decreed upon the believers a decree of specified times.” (Surah An-Nisa 4:103)",
      );
    }

    // 5. Qiblah direction inquiries
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
      );
    }

    // 6. Duas / Supplications / Anxiety / Sadness / Protection
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
        englishReference: "“And when My servants ask you concerning Me, indeed I am near. I respond to the invocation of the supplicant when he calls upon Me.” (Surah Al-Baqarah 2:186)",
      );
    }

    // 7. Fasting / Ramadan / Suhoor / Iftar inquiries
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
            "• **Suhoor**: The pre-dawn meal before Fajr. The Prophet (ﷺ) said: *'Eat Suhoor, for in Suhoor there is blessing.'* (Bukhari & Muslim).\n"
            "• **Iftar Dua**: `ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ` (*'The thirst is gone, the veins are moistened, and the reward is confirmed, if Allah wills.'*)\n\n"
            "Check live countdowns to Suhoor and Iftar in our **Fasting Tracker**!",
        suggestedRoute: "fasting",
        suggestedRouteLabel: "Open Fasting Tracker",
        arabicReference: "كُتِبَ عَلَيْكُمُ ٱلصِّيَامُ كَمَا كُتِبَ عَلَى ٱلَّذِينَ مِن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ",
        englishReference: "“Fasting is prescribed for you as it was prescribed for those before you, that you may attain Taqwa.” (Surah Al-Baqarah 2:183)",
      );
    }

    // 8. Zakat / Sadaqah / Charity inquiries
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
        englishReference: "“Take from their wealth a charity by which you purify them and cause them increase...” (Surah At-Tawbah 9:103)",
      );
    }

    // 9. Audio / Radio / Podcast inquiries
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
      );
    }

    // Default friendly Islamic response
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
          "• Or how to navigate any feature in MyIslam!\n\n"
          "How can I assist your spiritual journey today?",
      suggestedRoute: "home",
      suggestedRouteLabel: "Explore Features",
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
      default:
        return "View in App";
    }
  }
}
