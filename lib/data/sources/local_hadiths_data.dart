import '../models/hadith_model.dart';

class LocalHadithsData {
  static const List<Map<String, String>> dailyHadiths = [
    {
      "text": "The best among you are those who have the best manners and character.",
      "source": "Sahih Al-Bukhari & At-Tirmidhi",
      "narrator": "The Messenger of Allah ﷺ said",
    },
    {
      "text": "None of you truly believes until he loves for his brother what he loves for himself.",
      "source": "Sahih Al-Bukhari & Muslim",
      "narrator": "The Prophet ﷺ said",
    },
    {
      "text": "The strong man is not the one who overcomes others by force, but the one who controls himself while in anger.",
      "source": "Sahih Al-Bukhari",
      "narrator": "The Prophet ﷺ said",
    },
    {
      "text": "Make things easy and do not make them difficult, cheer people up and do not drive them away.",
      "source": "Sahih Al-Bukhari",
      "narrator": "The Prophet ﷺ said",
    },
    {
      "text": "Whoever believes in Allah and the Last Day should speak good or keep silent.",
      "source": "Sahih Al-Bukhari & Muslim",
      "narrator": "The Prophet ﷺ said",
    },
    {
      "text": "Smiling at your brother is an act of charity.",
      "source": "At-Tirmidhi",
      "narrator": "The Prophet ﷺ said",
    },
  ];

  static const List<Map<String, String>> dailyVerses = [
    {
      "text": "Indeed, with hardship will be ease.",
      "source": "Surah Ash-Sharh 94:6",
      "arabic": "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا",
    },
    {
      "text": "And He is with you wherever you are.",
      "source": "Surah Al-Hadid 57:4",
      "arabic": "وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ",
    },
    {
      "text": "So remember Me; I will remember you.",
      "source": "Surah Al-Baqarah 2:152",
      "arabic": "فَاذْكُرُونِي أَذْكُرْكُمْ",
    },
    {
      "text": "Verily, Allah is with the patient.",
      "source": "Surah Al-Baqarah 2:153",
      "arabic": "إِنَّ اللَّهَ مَعَ الصَّابِرِينَ",
    },
    {
      "text": "And Allah is the best of planners.",
      "source": "Surah Al-Anfal 8:30",
      "arabic": "وَاللَّهُ خَيْرُ الْمَاكِرِينَ",
    },
  ];

  static const List<HadithCategory> categories = [
    HadithCategory(
      id: 1,
      category: "Faith & Belief",
      categoryArabic: "الإيمان",
      hadiths: [
        HadithItem(
          arabic: "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ",
          translation: "Actions are judged by intentions.",
          narrator: "Umar ibn Al-Khattab",
          source: "Sahih Bukhari 1, Sahih Muslim 1907",
          explanation: "This foundational hadith teaches that the value of any action depends on the intention behind it.",
        ),
        HadithItem(
          arabic: "لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ",
          translation: "None of you truly believes until he loves for his brother what he loves for himself.",
          narrator: "Anas ibn Malik",
          source: "Sahih Bukhari 13, Sahih Muslim 45",
          explanation: "True faith is demonstrated through genuine concern for others' wellbeing.",
        ),
      ],
    ),
    HadithCategory(
      id: 2,
      category: "Good Character",
      categoryArabic: "حسن الخلق",
      hadiths: [
        HadithItem(
          arabic: "أَكْمَلُ الْمُؤْمِنِينَ إِيمَانًا أَحْسَنُهُمْ خُلُقًا",
          translation: "The most complete believers in faith are those with the best character.",
          narrator: "Abu Hurairah",
          source: "Sunan At-Tirmidhi 1162",
          explanation: "Good character is a sign of strong faith and is beloved to Allah.",
        ),
        HadithItem(
          arabic: "تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ",
          translation: "Your smile for your brother is charity.",
          narrator: "Abu Dharr",
          source: "Sunan At-Tirmidhi 1956",
          explanation: "Even small acts of kindness carry great reward.",
        ),
      ],
    ),
  ];
}
