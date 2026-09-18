/// Authentic 604-page King Fahd Glorious Quran Printing Complex (Madani) Page Data
class MushafPageData {
  static const int totalPages = 604;

  /// High-resolution King Fahd Complex Madani Mushaf page image URL
  static String getPageImageUrl(int page) {
    final clamped = page.clamp(1, totalPages);
    final formatted = clamped.toString().padLeft(3, '0');
    return 'https://files.quran.app/hafs/madani/width_1024/page$formatted.png';
  }

  /// Start page for each of the 30 Juz
  static const List<int> juzStartPages = [
    1,   // Juz 1
    22,  // Juz 2
    42,  // Juz 3
    62,  // Juz 4
    82,  // Juz 5
    102, // Juz 6
    121, // Juz 7
    142, // Juz 8
    162, // Juz 9
    182, // Juz 10
    201, // Juz 11
    222, // Juz 12
    242, // Juz 13
    262, // Juz 14
    282, // Juz 15
    302, // Juz 16
    322, // Juz 17
    342, // Juz 18
    362, // Juz 19
    382, // Juz 20
    402, // Juz 21
    422, // Juz 22
    442, // Juz 23
    462, // Juz 24
    482, // Juz 25
    502, // Juz 26
    522, // Juz 27
    542, // Juz 28
    562, // Juz 29
    582, // Juz 30
  ];

  /// Arabic Juz titles
  static const List<String> juzTitlesArabic = [
    "الجُزْءُ ١ (الم)",
    "الجُزْءُ ٢ (سَيَقُولُ)",
    "الجُزْءُ ٣ (تِلْكَ الرُّسُلُ)",
    "الجُزْءُ ٤ (لَنْ تَنَالُوا)",
    "الجُزْءُ ٥ (وَالْمُحْصَنَاتُ)",
    "الجُزْءُ ٦ (لَا يُحِبُّ اللَّهُ)",
    "الجُزْءُ ٧ (وَإِذَا سَمِعُوا)",
    "الجُزْءُ ٨ (وَلَوْ أَنَّنَا)",
    "الجُزْءُ ٩ (قَالَ الْمَلَأُ)",
    "الجُزْءُ ١٠ (وَاعْلَمُوا)",
    "الجُزْءُ ١١ (يَعْتَذِرُونَ)",
    "الجُزْءُ ١٢ (وَمَا مِنْ دَابَّةٍ)",
    "الجُزْءُ ١٣ (وَمَا أُبَرِّئُ)",
    "الجُزْءُ ١٤ (رُبَمَا)",
    "الجُزْءُ ١٥ (سُبْحَانَ الَّذِي)",
    "الجُزْءُ ١٦ (قَالَ أَلَمْ)",
    "الجُزْءُ ١٧ (اقْتَرَبَ)",
    "الجُزْءُ ١٨ (قَدْ أَفْلَحَ)",
    "الجُزْءُ ١٩ (وَقَالَ الَّذِينَ)",
    "الجُزْءُ ٢٠ (أَمَّنْ خَلَقَ)",
    "الجُزْءُ ٢١ (اتْلُ مَا أُوحِيَ)",
    "الجُزْءُ ٢٢ (وَمَنْ يَقْنُتْ)",
    "الجُزْءُ ٢٣ (وَمَا لِيَ)",
    "الجُزْءُ ٢٤ (فَمَنْ أَظْلَمُ)",
    "الجُزْءُ ٢٥ (إِلَيْهِ يُرَدُّ)",
    "الجُزْءُ ٢٦ (حم)",
    "الجُزْءُ ٢٧ (قَالَ فَمَا خَطْبُكُمْ)",
    "الجُزْءُ ٢٨ (قَدْ سَمِعَ اللَّهُ)",
    "الجُزْءُ ٢٩ (تَبَارَكَ الَّذِي)",
    "الجُزْءُ ٣٠ (عَمَّ)",
  ];

  /// Get Juz number (1-30) for a given page
  static int getJuzForPage(int page) {
    final p = page.clamp(1, totalPages);
    for (int i = juzStartPages.length - 1; i >= 0; i--) {
      if (p >= juzStartPages[i]) {
        return i + 1;
      }
    }
    return 1;
  }

  /// Start page for each of the 114 Surahs
  static const Map<int, int> surahStartPages = {
    1: 1, 2: 2, 3: 50, 4: 77, 5: 106, 6: 128, 7: 151, 8: 177, 9: 187, 10: 208,
    11: 221, 12: 235, 13: 249, 14: 255, 15: 262, 16: 267, 17: 282, 18: 293, 19: 305, 20: 312,
    21: 322, 22: 332, 23: 342, 24: 350, 25: 359, 26: 367, 27: 377, 28: 385, 29: 396, 30: 404,
    31: 411, 32: 415, 33: 418, 34: 428, 35: 434, 36: 440, 37: 446, 38: 453, 39: 458, 40: 467,
    41: 477, 42: 483, 43: 489, 44: 496, 45: 499, 46: 502, 47: 507, 48: 511, 49: 515, 50: 518,
    51: 520, 52: 523, 53: 526, 54: 528, 55: 531, 56: 534, 57: 537, 58: 542, 59: 545, 60: 549,
    61: 551, 62: 553, 63: 554, 64: 556, 65: 558, 66: 560, 67: 562, 68: 564, 69: 566, 70: 568,
    71: 570, 72: 572, 73: 574, 74: 575, 75: 577, 76: 578, 77: 580, 78: 582, 79: 583, 80: 585,
    81: 586, 82: 587, 83: 587, 84: 589, 85: 590, 86: 591, 87: 591, 88: 592, 89: 593, 90: 594,
    91: 595, 92: 595, 93: 596, 94: 596, 95: 597, 96: 597, 97: 598, 98: 598, 99: 599, 100: 599,
    101: 600, 102: 600, 103: 601, 104: 601, 105: 601, 106: 602, 107: 602, 108: 602, 109: 603,
    110: 603, 111: 603, 112: 604, 113: 604, 114: 604,
  };

  /// Surah English names by number (1-114)
  static const Map<int, String> surahNames = {
    1: "Al-Faatiha", 2: "Al-Baqarah", 3: "Aal-i-Imraan", 4: "An-Nisaa", 5: "Al-Maaida",
    6: "Al-An'aam", 7: "Al-A'raaf", 8: "Al-Anfaal", 9: "At-Tawba", 10: "Yoonus",
    11: "Hood", 12: "Yoosuf", 13: "Ar-Ra'd", 14: "Ibraaheem", 15: "Al-Hijr",
    16: "An-Nahl", 17: "Al-Israa", 18: "Al-Kahf", 19: "Maryam", 20: "Taa-Haa",
    21: "Al-Anbiyaa", 22: "Al-Hajj", 23: "Al-Muminoon", 24: "An-Noor", 25: "Al-Furqaan",
    26: "Ash-Shu'araa", 27: "An-Naml", 28: "Al-Qasas", 29: "Al-Ankaboot", 30: "Ar-Room",
    31: "Luqman", 32: "As-Sajda", 33: "Al-Ahzaab", 34: "Saba", 35: "Faatir",
    36: "Yaseen", 37: "As-Saaffaat", 38: "Saad", 39: "Az-Zumar", 40: "Ghafir",
    41: "Fussilat", 42: "Ash-Shoora", 43: "Az-Zukhruf", 44: "Ad-Dukhaan", 45: "Al-Jaathiya",
    46: "Al-Ahqaf", 47: "Muhammad", 48: "Al-Fath", 49: "Al-Hujuraat", 50: "Qaaf",
    51: "Adh-Dhaariyaat", 52: "At-Toor", 53: "An-Najm", 54: "Al-Qamar", 55: "Ar-Rahmaan",
    56: "Al-Waaqia", 57: "Al-Hadeed", 58: "Al-Mujaadila", 59: "Al-Hashr", 60: "Al-Mumtahana",
    61: "As-Saff", 62: "Al-Jumu'a", 63: "Al-Munaafiqoon", 64: "At-Taghaabun", 65: "At-Talaaq",
    66: "At-Tahreem", 67: "Al-Mulk", 68: "Al-Qalam", 69: "Al-Haaqqa", 70: "Al-Ma'aarij",
    71: "Nooh", 72: "Al-Jinn", 73: "Al-Muzzammil", 74: "Al-Muddaththir", 75: "Al-Qiyaama",
    76: "Al-Insaan", 77: "Al-Mursalaat", 78: "An-Naba", 79: "An-Naazi'aat", 80: "Abasa",
    81: "At-Takweer", 82: "Al-Infitaar", 83: "Al-Mutaffifeen", 84: "Al-Inshiqaaq", 85: "Al-Burooj",
    86: "At-Taariq", 87: "Al-A'laa", 88: "Al-Ghaashiya", 89: "Al-Fajr", 90: "Al-Balad",
    91: "Ash-Shams", 92: "Al-Layl", 93: "Ad-Dhuha", 94: "Ash-Sharh", 95: "At-Teen",
    96: "Al-Alaq", 97: "Al-Qadr", 98: "Al-Bayyina", 99: "Az-Zalzala", 100: "Al-Aadiyaat",
    101: "Al-Qaari'a", 102: "At-Takaathur", 103: "Al-Asr", 104: "Al-Humaza", 105: "Al-Feel",
    106: "Quraysh", 107: "Al-Maa'oon", 108: "Al-Kawthar", 109: "Al-Kaafiroon", 110: "An-Nasr",
    111: "Al-Masad", 112: "Al-Ikhlaas", 113: "Al-Falaq", 114: "An-Naas",
  };

  /// Surah Arabic names by number (1-114)
  static const Map<int, String> surahNamesArabic = {
    1: "الفاتحة", 2: "البقرة", 3: "آل عمران", 4: "النساء", 5: "المائدة",
    6: "الأنعام", 7: "الأعراف", 8: "الأنفال", 9: "التوبة", 10: "يونس",
    11: "هود", 12: "يوسف", 13: "الرعد", 14: "إبراهيم", 15: "الحجر",
    16: "النحل", 17: "الإسراء", 18: "الكهف", 19: "مريم", 20: "طه",
    21: "الأنبياء", 22: "الحج", 23: "المؤمنون", 24: "النور", 25: "الفرقان",
    26: "الشعراء", 27: "النمل", 28: "القصص", 29: "العنكبوت", 30: "الروم",
    31: "لقمان", 32: "السجدة", 33: "الأحزاب", 34: "سبأ", 35: "فاطر",
    36: "يس", 37: "الصافات", 38: "ص", 39: "الزمر", 40: "غافر",
    41: "فصلت", 42: "الشورى", 43: "الزخرف", 44: "الدخان", 45: "الجاثية",
    46: "الأحقاف", 47: "محمد", 48: "الفتح", 49: "الحجرات", 50: "ق",
    51: "الذاريات", 52: "الطور", 53: "النجم", 54: "القمر", 55: "الرحمن",
    56: "الواقعة", 57: "الحديد", 58: "المجادلة", 59: "الحشر", 60: "الممتحنة",
    61: "الصف", 62: "الجمعة", 63: "المنافقون", 64: "التغابن", 65: "الطلاق",
    66: "التحريم", 67: "الملك", 68: "القلم", 69: "الحاقة", 70: "المعارج",
    71: "نوح", 72: "الجن", 73: "المزمل", 74: "المدثر", 75: "القيامة",
    76: "الإنسان", 77: "المرسلات", 78: "النبأ", 79: "النازعات", 80: "عبس",
    81: "التكوير", 82: "الانفطار", 83: "المطففين", 84: "الانشقاق", 85: "البروج",
    86: "الطارق", 87: "الأعلى", 88: "الغاشية", 89: "الفجر", 90: "البلد",
    91: "الشمس", 92: "الليل", 93: "الضحى", 94: "الشرح", 95: "التين",
    96: "العلق", 97: "القدر", 98: "البينة", 99: "الزلزلة", 100: "العاديات",
    101: "القارعة", 102: "التكاثر", 103: "العصر", 104: "الهمزة", 105: "الفيل",
    106: "قريش", 107: "الماعون", 108: "الكوثر", 109: "الكافرون", 110: "النصر",
    111: "المسد", 112: "الإخلاص", 113: "الفلق", 114: "الناس",
  };

  /// Determine the primary Surah number present on a given page
  static int getPrimarySurahNumberForPage(int page) {
    final p = page.clamp(1, totalPages);
    int currentSurah = 1;
    for (int s = 1; s <= 114; s++) {
      final start = surahStartPages[s] ?? 1;
      if (p >= start) {
        currentSurah = s;
      } else {
        break;
      }
    }
    return currentSurah;
  }
}
