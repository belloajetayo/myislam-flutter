class HijriDate {
  final int day;
  final int month; // 1-12
  final int year;
  final String monthName;
  final String monthArabic;

  const HijriDate({
    required this.day,
    required this.month,
    required this.year,
    required this.monthName,
    required this.monthArabic,
  });

  static const List<String> monthNames = [
    "Muharram",
    "Safar",
    "Rabi' al-Awwal",
    "Rabi' al-Thani",
    "Jumada al-Awwal",
    "Jumada al-Thani",
    "Rajab",
    "Sha'ban",
    "Ramadan",
    "Shawwal",
    "Dhul Qi'dah",
    "Dhul Hijjah",
  ];

  static const List<String> monthArabicNames = [
    "مُحَرَّم",
    "صَفَر",
    "رَبِيع الأَوَّل",
    "رَبِيع الآخِر",
    "جُمَادَى الأُولَى",
    "جُمَادَى الآخِرَة",
    "رَجَب",
    "شَعْبَان",
    "رَمَضَان",
    "شَوَّال",
    "ذُو القَعْدَة",
    "ذُو الحِجَّة",
  ];

  String get formatted => "$day $monthName $year AH";
  String get formattedArabic => "$day $monthArabic $year هـ";

  /// Returns whether this day is one of the White Days (Ayyam al-Beed: 13, 14, 15)
  static bool isWhiteDay(int day) => day >= 13 && day <= 15;

  /// Days in a specific Hijri month
  static int daysInMonth(int year, int month) {
    if (month == 12) {
      final isLeap = (11 * year + 14) % 30 < 11;
      return isLeap ? 30 : 29;
    }
    return month.isOdd ? 30 : 29;
  }

  /// Algorithmic conversion from Gregorian DateTime to HijriDate
  static HijriDate fromGregorian(DateTime date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;

    final jdn = ((1461 * (y + 4800 + ((m - 14) ~/ 12))) ~/ 4) +
        ((367 * (m - 2 - 12 * ((m - 14) ~/ 12))) ~/ 12) -
        ((3 * ((y + 4900 + ((m - 14) ~/ 12)) ~/ 100)) ~/ 4) +
        d -
        32075;

    final l = jdn - 1948440 + 10632;
    final n = l ~/ 10631;
    final l2 = l - 10631 * n + 354;
    final j = ((10985 - l2) ~/ 5316) * ((50 * l2) ~/ 17719) +
        (l2 ~/ 5670) * ((43 * l2) ~/ 15238);
    final l3 = l2 -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final month = (24 * l3) ~/ 709;
    final day = l3 - ((709 * month) ~/ 24);
    final year = 30 * n + j - 30;

    final safeMonth = month.clamp(1, 12);
    return HijriDate(
      day: day,
      month: safeMonth,
      year: year,
      monthName: monthNames[safeMonth - 1],
      monthArabic: monthArabicNames[safeMonth - 1],
    );
  }

  /// Convert Hijri date to approximate Gregorian DateTime
  static DateTime toGregorian(int hYear, int hMonth, int hDay) {
    final jdn = ((11 * hYear + 3) ~/ 30) +
        354 * hYear +
        30 * hMonth -
        ((hMonth - 1) ~/ 2) +
        hDay +
        1948440 -
        385;

    final l = jdn + 68569;
    final n = (4 * l) ~/ 146097;
    final l2 = l - ((146097 * n + 3) ~/ 4);
    final i = (4000 * (l2 + 1)) ~/ 1461001;
    final l3 = l2 - ((1461 * i) ~/ 4) + 31;
    final j = (80 * l3) ~/ 2447;
    final day = l3 - ((2447 * j) ~/ 80);
    final l4 = j ~/ 11;
    final month = j + 2 - (12 * l4);
    final year = 100 * (n - 49) + i + l4;

    return DateTime(year, month.clamp(1, 12), day.clamp(1, 31));
  }

  /// Major Islamic historical milestones and holidays
  static const List<IslamicEvent> keyEvents = [
    IslamicEvent(
      month: 1,
      day: 1,
      name: "Islamic New Year",
      arabic: "رَأْسُ السَّنَةِ الهِجْرِيَّة",
      description: "First day of Muharram and beginning of the Islamic lunar calendar.",
      virtue: "One of the four sacred months (Al-Ashhur Al-Hurum). Good deeds earn multiplied rewards.",
      isHoliday: true,
      icon: "🌙",
    ),
    IslamicEvent(
      month: 1,
      day: 10,
      name: "Day of Ashura",
      arabic: "يَوْم عَاشُورَاء",
      description: "The day Allah saved Prophet Musa (Moses) and Bani Israel from Pharaoh.",
      virtue: "The Prophet ﷺ said fasting Ashura expiates sins of the previous year (Sahih Muslim 1162).",
      isHoliday: false,
      icon: "✨",
    ),
    IslamicEvent(
      month: 3,
      day: 12,
      name: "Mawlid an-Nabi",
      arabic: "المَوْلِد النَّبَوِيّ الشَّرِيف",
      description: "Commemoration of the birth and blessed life of Prophet Muhammad ﷺ.",
      virtue: "Sending abundant Salawat, studying the Seerah, and following the Sunnah.",
      isHoliday: true,
      icon: "🌸",
    ),
    IslamicEvent(
      month: 7,
      day: 27,
      name: "Al-Isra' wal-Mi'raj",
      arabic: "الإِسْرَاء وَالمِعْرَاج",
      description: "The miraculous night journey from Makkah to Jerusalem and ascension to the Heavens.",
      virtue: "The gift of the 5 daily prayers (Salah) was bestowed upon the Ummah on this blessed night.",
      isHoliday: false,
      icon: "🌌",
    ),
    IslamicEvent(
      month: 8,
      day: 15,
      name: "Mid-Sha'ban (Nisf Sha'ban)",
      arabic: "لَيْلَة النِّصْف مِنْ شَعْبَان",
      description: "Night of divine mercy and forgiveness before the arrival of Ramadan.",
      virtue: "Prophet Muhammad ﷺ fasted frequently in Sha'ban as deeds are raised to Allah.",
      isHoliday: false,
      icon: "🕊️",
    ),
    IslamicEvent(
      month: 9,
      day: 1,
      name: "First Day of Ramadan",
      arabic: "أَوَّل رَمَضَان المُبَارَك",
      description: "Beginning of the holy month of obligatory fasting, Quran recitation, and Taraweeh.",
      virtue: "Gates of Heaven are opened, gates of Hell are closed, and devils are chained (Bukhari).",
      isHoliday: true,
      icon: "⭐",
    ),
    IslamicEvent(
      month: 9,
      day: 17,
      name: "Battle of Badr",
      arabic: "غَزْوَة بَدْر الكُبْرَى",
      description: "Yawm al-Furqan: the decisive historic victory of truth over falsehood in Ramadan 2 AH.",
      virtue: "Steadfast faith, reliance on Allah (Tawakkul), and divine angelic assistance.",
      isHoliday: false,
      icon: "🛡️",
    ),
    IslamicEvent(
      month: 9,
      day: 21,
      name: "Start of Last 10 Nights",
      arabic: "العَشْر الأَوَاخِر مِنْ رَمَضَان",
      description: "The most sacred nights of the year; spiritual seclusion (I'tikaf) and intense worship.",
      virtue: "Seeking Laylatul Qadr across the odd nights (21, 23, 25, 27, 29).",
      isHoliday: false,
      icon: "🕯️",
    ),
    IslamicEvent(
      month: 9,
      day: 27,
      name: "Laylatul Qadr (Night of Decree)",
      arabic: "لَيْلَة القَدْر",
      description: "The night the Holy Quran was revealed from the Preserved Tablet.",
      virtue: "Worship on this single night is better than worshiping for 1,000 months (83+ years).",
      isHoliday: true,
      icon: "👑",
    ),
    IslamicEvent(
      month: 10,
      day: 1,
      name: "Eid al-Fitr",
      arabic: "عِيد الفِطْر المُبَارَك",
      description: "Celebration of completing the month of Ramadan with Takbeerat, Salat, and Zakat al-Fitr.",
      virtue: "Day of joy, community unity, feeding the poor, and thanking Allah for guidance.",
      isHoliday: true,
      icon: "🎉",
    ),
    IslamicEvent(
      month: 12,
      day: 1,
      name: "First 10 Days of Dhul Hijjah",
      arabic: "عَشْر ذِي الحِجَّة",
      description: "The most virtuous ten days of the entire Islamic year.",
      virtue: "Good deeds during these 10 days are more beloved to Allah than any other days (Bukhari).",
      isHoliday: false,
      icon: "🕋",
    ),
    IslamicEvent(
      month: 12,
      day: 8,
      name: "Yawm at-Tarwiyah",
      arabic: "يَوْم التَّرْوِيَة",
      description: "Pilgrims put on Ihram and set out to Mina for the start of Hajj rituals.",
      virtue: "Remembering Allah in anticipation of the monumental Day of Arafah.",
      isHoliday: false,
      icon: "⛺",
    ),
    IslamicEvent(
      month: 12,
      day: 9,
      name: "Day of Arafah",
      arabic: "يَوْم عَرَفَة",
      description: "The pinnacle of the Hajj pilgrimage where pilgrims stand in prayer at Mount Arafat.",
      virtue: "Fasting on Arafah expiates sins of the previous year and the coming year for non-pilgrims.",
      isHoliday: true,
      icon: "⛰️",
    ),
    IslamicEvent(
      month: 12,
      day: 10,
      name: "Eid al-Adha",
      arabic: "عِيد الأَضْحَى المُبَارَك",
      description: "The Great Feast of Sacrifice commemorating Prophet Ibrahim's obedience (Qurbani / Udhiyah).",
      virtue: "Eid prayer, slaughtering sacrificial livestock for Allah, and distributing to family and the needy.",
      isHoliday: true,
      icon: "🐑",
    ),
    IslamicEvent(
      month: 12,
      day: 11,
      name: "Ayyam at-Tashreeq",
      arabic: "أَيَّام التَّشْرِيق",
      description: "Three consecutive days following Eid al-Adha (11-13 Dhul Hijjah).",
      virtue: "Days of eating, drinking, and remembrance of Allah (Takbeerat). Fasting is forbidden.",
      isHoliday: false,
      icon: "🍖",
    ),
  ];

  static IslamicEvent? getEventFor(int month, int day) {
    for (final event in keyEvents) {
      if (event.month == month && event.day == day) {
        return event;
      }
    }
    return null;
  }
}

class IslamicEvent {
  final int month;
  final int day;
  final String name;
  final String arabic;
  final String description;
  final String virtue;
  final bool isHoliday;
  final String icon;

  const IslamicEvent({
    required this.month,
    required this.day,
    required this.name,
    required this.arabic,
    required this.description,
    required this.virtue,
    required this.icon,
    this.isHoliday = false,
  });
}
