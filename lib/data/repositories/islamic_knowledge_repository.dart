enum AiAudienceMode {
  muslim,
  seeker, // For non-Muslims, seekers, and curious learners
}

class IslamicKnowledgeItem {
  final String id;
  final List<String> keywords;
  final String topic;
  final String arabicAyahOrHadith;
  final String englishText;
  final String scholarlyReference;
  final String? suggestedRoute;
  final String? suggestedRouteLabel;
  final AiAudienceMode audience;

  const IslamicKnowledgeItem({
    required this.id,
    required this.keywords,
    required this.topic,
    required this.arabicAyahOrHadith,
    required this.englishText,
    required this.scholarlyReference,
    this.suggestedRoute,
    this.suggestedRouteLabel,
    this.audience = AiAudienceMode.muslim,
  });
}

class IslamicKnowledgeRepository {
  // =========================================================================
  // 1. ISLAMQA & FIQH TOPICS (PRACTICAL RULINGS & HADITH CORPUS)
  // =========================================================================
  static const List<IslamicKnowledgeItem> fiqhAndIslamQa = [
    // Wudu doubts / invalidators
    IslamicKnowledgeItem(
      id: "fiqh-wudu-doubts",
      keywords: ["wudu", "wudhu", "ablution", "doubt", "invalidate", "break wudu", "flatulence", "gas"],
      topic: "Doubts About Invalidating Wudu",
      arabicAyahOrHadith: "لَا يَنْصَرِفْ حَتَّى يَسْمَعَ صَوْتًا أَوْ يَجِدَ رِيحًا",
      englishText:
          "According to scholarly consensus and IslamQA (#8918), pure doubts or intrusive thoughts (*waswas*) do not invalidate your Wudu.\n\n"
          "The Prophet ﷺ established the golden rule: **Certainty is not overturned by mere doubt.** A person should remain in their prayer or state of purity until they are absolutely certain (e.g., they distinctly hear a sound or perceive an odor).\n\n"
          "• **Invalidators of Wudu**: Natural discharges from either passage, deep sleep where consciousness is lost, eating camel meat (Hanbali), or direct touching of the private parts without barrier.",
      scholarlyReference: "Sahih al-Bukhari 137 | Sahih Muslim 361 | IslamQA #8918",
      suggestedRoute: "prayer",
      suggestedRouteLabel: "Check Prayer Times",
    ),

    // Forgetfulness in Prayer (Sujood as-Sahw)
    IslamicKnowledgeItem(
      id: "fiqh-sujood-sahw",
      keywords: ["forget", "sahw", "sujood sahw", "missed rakah", "doubt rakah", "mistake in prayer"],
      topic: "Sujood as-Sahw (Prostrations of Forgetfulness)",
      arabicAyahOrHadith: "إِذَا شَكَّ أَحَدُكُمْ فِي صَلَاتِهِ فَلْيَبْنِ عَلَى مَا اسْتَيْقَنَ",
      englishText:
          "If you doubt how many rak'ahs you have prayed (e.g., 3 or 4), base your prayer on **what is certain**—which is the lesser amount—complete the prayer, and perform two prostrations (*Sujood as-Sahw*) before or after Tasleem (IslamQA #11244).\n\n"
          "• **Before Tasleem**: If you omitted a mandatory act (like the first Tashahhud) or had a doubt without being able to decide.\n"
          "• **After Tasleem**: If you mistakenly added something (like an extra rak'ah) or resolved your doubt with strong certainty.",
      scholarlyReference: "Sahih Muslim 571 | IslamQA #11244",
      suggestedRoute: "prayer",
      suggestedRouteLabel: "View Prayer Guide",
    ),

    // Fasting Doubts (Eating by mistake, eye drops)
    IslamicKnowledgeItem(
      id: "fiqh-fasting-eating-mistake",
      keywords: ["fasting mistake", "ate by mistake", "drank water by mistake", "break fast", "forget fast", "drops", "inhaler"],
      topic: "Eating or Drinking by Mistake While Fasting",
      arabicAyahOrHadith: "مَنْ نَسِيَ وَهُوَ صَائِمٌ فَأَكَلَ أَوْ شَرِبَ فَلْيُتِمَّ صَوْمَهُ فَإِنَّمَا أَطْعَمَهُ اللَّهُ وَسَقَاهُ",
      englishText:
          "If you accidentally eat or drink out of forgetfulness while fasting, **your fast remains 100% valid and complete**! (IslamQA #22960).\n\n"
          "The Prophet ﷺ said: *'Whoever forgets that he is fasting and eats or drinks, let him complete his fast, for it was Allah Who fed him and gave him drink.'*\n\n"
          "• **Eye/ear drops & asthma inhalers**: The Islamic Fiqh Academy and major contemporary scholars ruled that medical inhalers and non-nutritive eye drops do not invalidate the fast because they do not constitute food or drink.",
      scholarlyReference: "Sahih al-Bukhari 1933 | Sahih Muslim 1155 | IslamQA #22960",
      suggestedRoute: "fasting",
      suggestedRouteLabel: "Open Fasting Tracker",
    ),

    // Repentance & Despair (Tawbah)
    IslamicKnowledgeItem(
      id: "fiqh-tawbah-repentance",
      keywords: ["tawbah", "repent", "forgive", "major sin", "despair", "guilt", "lost", "addiction"],
      topic: "The Door of Sincere Repentance (Tawbah)",
      arabicAyahOrHadith: "قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ ۚ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا",
      englishText:
          "Never despair of the mercy of Allah, no matter how severe your sins may seem! Allah’s mercy encompasses everything.\n\n"
          "Scholars of IslamQA (#14289) explain the **3 Conditions of Sincere Tawbah**:\n"
          "1. **Immediate Cessation**: Stop committing the sin right away.\n"
          "2. **Deep Regret**: Sincere remorse in your heart for violating Allah's boundary.\n"
          "3. **Firm Intention**: A steadfast resolve never to return to it.\n"
          "*(If the sin wronged another person, returning their right or seeking their forgiveness is a 4th condition)*.",
      scholarlyReference: "Surah Az-Zumar 39:53 | IslamQA #14289",
      suggestedRoute: "duas",
      suggestedRouteLabel: "Read Sayyidul Istighfar",
    ),

    // Zakat on Wealth, Gold & 401k
    IslamicKnowledgeItem(
      id: "fiqh-zakat-nisab",
      keywords: ["zakat calculation", "nisab", "gold zakat", "silver zakat", "401k", "stocks", "cash zakat"],
      topic: "Zakat Nisab & Wealth Purification",
      arabicAyahOrHadith: "وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ وَأَقْرِضُوا اللَّهَ قَرْضًا حَسَنًا",
      englishText:
          "Zakat is obligatory on every Muslim whose net wealth exceeds the **Nisab threshold** for one full lunar year (*Hawl*).\n\n"
          "• **Nisab Standard**: Equivalent to **85 grams of pure gold (24k)** or **595 grams of silver**.\n"
          "• **Payable Rate**: **2.5%** on qualifying assets: liquid cash, bank accounts, physical gold/silver, trade inventory, and vested retirement balances/shares.\n"
          "• Debts due immediately and everyday personal necessities (house, personal car, clothes) are excluded from the calculation.",
      scholarlyReference: "Surah Al-Muzzammil 73:20 | IslamQA #50801",
      suggestedRoute: "zakat",
      suggestedRouteLabel: "Open Zakat Calculator",
    ),
  ];

  // =========================================================================
  // 2. INTERFAITH & DISCOVERY TOPICS (FOR NON-MUSLIMS & NEW LEARNERS)
  // =========================================================================
  static const List<IslamicKnowledgeItem> interfaithTopics = [
    // What is Islam?
    IslamicKnowledgeItem(
      id: "interfaith-what-is-islam",
      keywords: ["what is islam", "islam meaning", "who are muslims", "basics of islam", "intro to islam"],
      topic: "What is Islam?",
      arabicAyahOrHadith: "إِنَّ الدِّينَ عِندَ اللَّهِ الْإِسْلَامُ",
      englishText:
          "Welcome! The word **Islam** comes from the Arabic root *s-l-m*, which means **peace, wholeness, and voluntary surrender to the One Creator**.\n\n"
          "A Muslim is simply anyone who believes in the One Supreme Creator (*Allah*) and strives to live a life of moral consciousness, mercy, and justice.\n\n"
          "Islam is not a new religion founded in the 7th century; Muslims believe it is the timeless primordial faith taught by all previous prophets throughout human history, including Adam, Noah, Abraham, Moses, David, Jesus, and finalized through Prophet Muhammad (peace be upon them all).",
      scholarlyReference: "Surah Ali 'Imran 3:19 | Bridge of Understanding",
      audience: AiAudienceMode.seeker,
      suggestedRoute: "home",
      suggestedRouteLabel: "Explore MyIslam Tour",
    ),

    // Who is Allah?
    IslamicKnowledgeItem(
      id: "interfaith-who-is-allah",
      keywords: ["who is allah", "allah", "is allah different", "god of muslims", "muslim god", "monotheism"],
      topic: "Who is Allah? Is He Different from God in Other Faiths?",
      arabicAyahOrHadith: "قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ",
      englishText:
          "**Allah** is not a 'Muslim God' or a distinct deity. It is simply the unique Arabic word for **The One and Only True God**, the Sovereign Creator of the universe.\n\n"
          "In fact, millions of Arabic-speaking Christians and Jews in the Middle East have used the word *Allah* in their Bibles and prayers for centuries before and after Islam!\n\n"
          "In Arabic, the word *Allah* is grammatically unique: it has no plural form (unlike 'gods') and no gender (unlike 'goddess'). He is One, without parents, partners, children, or equals—All-Merciful, All-Just, and Transcendent.",
      scholarlyReference: "Surah Al-Ikhlas 112:1-4 | Monotheism in Abrahamic Faiths",
      audience: AiAudienceMode.seeker,
      suggestedRoute: "quran",
      suggestedRouteLabel: "Read Surah Al-Ikhlas",
    ),

    // Who is Jesus (Isa) in Islam?
    IslamicKnowledgeItem(
      id: "interfaith-jesus-in-islam",
      keywords: ["jesus", "jesus in islam", "isa", "mary", "virgin mary", "crucifixion", "christ"],
      topic: "Prophet Jesus (Isa) & Mary (Maryam) in Islam",
      arabicAyahOrHadith: "إِنَّمَا الْمَسِيحُ عِيسَى ابْنُ مَرْيَمَ رَسُولُ اللَّهِ وَكَلِمَتُهُ أَلْقَاهَا إِلَىٰ مَرْيَمَ وَرُوحٌ مِّنْهُ",
      englishText:
          "Many people are surprised to discover that **Jesus (peace be upon him) is one of the greatest, most revered prophets in Islam**! A Muslim cannot be a Muslim without believing in and loving Jesus.\n\n"
          "Key Quranic facts about Jesus:\n"
          "• **Miraculous Virgin Birth**: Born without a father to the Virgin Mary (*Maryam*), who has an entire chapter named after her in the Quran (Surah 19) and is honored as the most noble woman of all creation.\n"
          "• **Miracles**: Jesus spoke from the cradle in infancy, healed the blind and lepers, and raised the dead—all by the permission and power of God.\n"
          "• **Messiah & Prophet**: Muslims revere Jesus as the Messiah (*Al-Maseeh*) and a noble Messenger of God, but not as God Himself or the biological son of God, for the Creator is far beyond human biological reproduction.\n"
          "• **Second Coming**: Muslims believe Jesus was raised to Heaven and will return to Earth before the Day of Judgment to establish peace and justice.",
      scholarlyReference: "Surah An-Nisa 4:171 | Surah Maryam 19:16-36",
      audience: AiAudienceMode.seeker,
      suggestedRoute: "quran",
      suggestedRouteLabel: "Explore Surah Maryam",
    ),

    // Women in Islam & Misconceptions
    IslamicKnowledgeItem(
      id: "interfaith-women-rights",
      keywords: ["women", "women in islam", "hijab", "oppression", "rights of women", "equality"],
      topic: "Women's Status and Rights in Islam",
      arabicAyahOrHadith: "وَلَهُنَّ مِثْلُ الَّذِي عَلَيْهِنَّ بِالْمَعْرُوفِ",
      englishText:
          "Over 1,400 years ago—centuries before Western societies granted women legal autonomy—Islam established radical protections for women:\n\n"
          "1. **Spiritual Equality**: The Quran explicitly emphasizes that men and women receive the exact same spiritual reward and accountability (Surah 33:35).\n"
          "2. **Financial Independence**: An Islamic woman retains 100% full ownership over her money, property, inheritance, and earnings. Her husband cannot touch a penny without her consent, while he is legally obligated to support all family expenses.\n"
          "3. **Education & Scholarship**: The Prophet ﷺ declared: *'Seeking knowledge is mandatory upon every Muslim (male and female).'* His wife Aisha was one of the most prolific jurists, scholars, and medical minds in Islamic history, teaching hundreds of male and female scholars.\n\n"
          "Cultural practices in certain regions should not be confused with the divine justice of Islamic law.",
      scholarlyReference: "Surah Al-Baqarah 2:228 | Surah Al-Ahzab 33:35",
      audience: AiAudienceMode.seeker,
      suggestedRoute: "home",
      suggestedRouteLabel: "App Home",
    ),

    // Science and the Quran
    IslamicKnowledgeItem(
      id: "interfaith-quran-and-science",
      keywords: ["science", "scientific miracles", "embryo", "universe", "big bang", "mountains", "oceans"],
      topic: "The Quran and Modern Scientific Discoveries",
      arabicAyahOrHadith: "أَوَلَمْ يَرَ الَّذِينَ كَفَرُوا أَنَّ السَّمَاوَاتِ وَالْأَرْضَ كَانَتَا رَتْقًا فَفَتَقْنَاهُمَا ۖ وَجَعَلْنَا مِنَ الْمَاءِ كُلَّ شَيْءٍ حَيٍّ",
      englishText:
          "The Quran is a book of spiritual guidance (*Ayat* / signs), not a science textbook. Yet it contains remarkable statements about natural phenomena revealed 14 centuries ago that align stunningly with modern empirical science:\n\n"
          "• **Cosmology & The Big Bang**: *'The heavens and the earth were a joined entity, then We separated them, and made from water every living thing.'* (Quran 21:30).\n"
          "• **Expanding Universe**: *'And the heaven We constructed with strength, and indeed, We are its expander.'* (Quran 51:47).\n"
          "• **Human Embryology**: The detailed sequential development of the human embryo from a drop into a clinging clot (*'Alaqah*) described in Surah Al-Mu'minun (23:12-14).\n"
          "• **Internal Ocean Waves & Deep Darkness**: Deep submarine internal waves and barriers between seas (Surah An-Nur 24:40 & Ar-Rahman 55:19-20).",
      scholarlyReference: "Surah Al-Anbiya 21:30 | Surah Adh-Dhariyat 51:47",
      audience: AiAudienceMode.seeker,
      suggestedRoute: "quran",
      suggestedRouteLabel: "Read Quran Tafsir",
    ),

    // How to Become a Muslim (The Shahadah)
    IslamicKnowledgeItem(
      id: "interfaith-convert-shahadah",
      keywords: ["convert", "revert", "become muslim", "shahada", "shahadah", "how to accept islam", "join islam"],
      topic: "How Does Someone Become a Muslim? (The Shahadah)",
      arabicAyahOrHadith: "أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا ٱللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ ٱللَّهِ",
      englishText:
          "Becoming a Muslim is beautiful, deeply personal, and remarkably simple. There are no complicated rituals, fees, or intermediaries needed between you and God.\n\n"
          "One becomes a Muslim by declaring with conviction and sincerity of heart the **Testimony of Faith (Shahadah)**:\n\n"
          "**“Ash-hadu an la ilaha illallah, wa ash-hadu anna Muhammadan Rasulullah.”**\n"
          "*('I bear witness that there is no deity worthy of worship except Allah, and I bear witness that Muhammad is the Messenger of Allah.')*\n\n"
          "Upon declaring this with sincere faith, all your previous sins are completely wiped clean, and you begin life with a pure, white spiritual slate. Welcome to a brotherhood and sisterhood of nearly 2 billion people worldwide!",
      scholarlyReference: "Sahih Muslim 121 | Becoming a Muslim",
      audience: AiAudienceMode.seeker,
      suggestedRoute: "home",
      suggestedRouteLabel: "Welcome to MyIslam",
    ),
  ];

  // Helper search across all items
  static List<IslamicKnowledgeItem> searchKnowledge(String query, {AiAudienceMode? mode}) {
    final clean = query.toLowerCase().trim();
    if (clean.isEmpty) return [];

    final all = [...fiqhAndIslamQa, ...interfaithTopics];
    return all.where((item) {
      if (mode != null && item.audience != mode) return false;
      return item.keywords.any((kw) => clean.contains(kw) || kw.contains(clean)) ||
          item.topic.toLowerCase().contains(clean) ||
          item.englishText.toLowerCase().contains(clean);
    }).toList();
  }

  static IslamicKnowledgeItem? findBestMatch(String query, {AiAudienceMode? mode}) {
    final results = searchKnowledge(query, mode: mode);
    if (results.isNotEmpty) return results.first;

    // Fallback: search without mode filter
    if (mode != null) {
      final fallback = searchKnowledge(query);
      if (fallback.isNotEmpty) return fallback.first;
    }
    return null;
  }
}
