import '../models/podcast_model.dart';

class LocalPodcastsData {
  static const List<String> categories = [
    "All",
    "Tafseer",
    "Seerah",
    "Heart Therapy",
    "Contemporary",
    "Youth & Family",
  ];

  static const List<PodcastShow> shows = [
    PodcastShow(
      id: "tafseer_gems",
      title: "The Divine Book: Quranic Gems",
      speaker: "Nouman Ali Khan & Bayyinah",
      description:
          "Deep linguistic insights, coherence, and practical life lessons unlocked from the miraculous verses of the Holy Quran.",
      category: "Tafseer",
      icon: "📖",
      rating: 4.98,
      episodes: [
        PodcastEpisode(
          id: "ep_fatiha",
          showId: "tafseer_gems",
          showTitle: "The Divine Book: Quranic Gems",
          speaker: "Nouman Ali Khan",
          title: "Surah Al-Fatiha: The Master Key to the Quran",
          description:
              "An inspiring verse-by-verse exploration of Umm al-Kitab, examining why it is recited in every unit of prayer.",
          duration: "21:40",
          estimatedDuration: Duration(minutes: 21, seconds: 40),
          audioUrl: "https://server8.mp3quran.net/afs/001.mp3",
          releaseDate: "12 Aug 2026",
          topic: "Umm al-Kitab",
        ),
        PodcastEpisode(
          id: "ep_kahf",
          showId: "tafseer_gems",
          showTitle: "The Divine Book: Quranic Gems",
          speaker: "Nouman Ali Khan",
          title: "Surah Al-Kahf: The Four Shields Against Dajjal",
          description:
              "Understanding the 4 foundational stories: Trial of Faith (Youth of Cave), Wealth, Knowledge (Musa & Khidr), and Power (Dhul-Qarnayn).",
          duration: "34:15",
          estimatedDuration: Duration(minutes: 34, seconds: 15),
          audioUrl: "https://server8.mp3quran.net/afs/018.mp3",
          releaseDate: "05 Aug 2026",
          topic: "Spiritual Shields",
        ),
        PodcastEpisode(
          id: "ep_yusuf",
          showId: "tafseer_gems",
          showTitle: "The Divine Book: Quranic Gems",
          speaker: "Nouman Ali Khan",
          title: "Surah Yusuf: The Best of Stories (Ahsan al-Qasas)",
          description:
              "How patience (Sabrun Jameel), emotional trauma, and trust in divine decree manifest through the life of Prophet Yusuf (AS).",
          duration: "42:10",
          estimatedDuration: Duration(minutes: 42, seconds: 10),
          audioUrl: "https://server8.mp3quran.net/afs/012.mp3",
          releaseDate: "28 Jul 2026",
          topic: "Patience & Triumph",
        ),
        PodcastEpisode(
          id: "ep_rahman",
          showId: "tafseer_gems",
          showTitle: "The Divine Book: Quranic Gems",
          speaker: "Nouman Ali Khan",
          title: "Surah Ar-Rahman: The Infinite Blessings of Allah",
          description:
              "Which of the favors of your Lord will you deny? A breathtaking linguistic and thematic study of divine benevolence.",
          duration: "26:30",
          estimatedDuration: Duration(minutes: 26, seconds: 30),
          audioUrl: "https://server8.mp3quran.net/afs/055.mp3",
          releaseDate: "15 Jul 2026",
          topic: "Gratitude & Creation",
        ),
        PodcastEpisode(
          id: "ep_mulk",
          showId: "tafseer_gems",
          showTitle: "The Divine Book: Quranic Gems",
          speaker: "Nouman Ali Khan",
          title: "Surah Al-Mulk: The Interceding Fortress in the Grave",
          description:
              "The Prophet ﷺ encouraged reciting Surah Al-Mulk every night. Unpack its profound questions about the universe and death.",
          duration: "18:45",
          estimatedDuration: Duration(minutes: 18, seconds: 45),
          audioUrl: "https://server8.mp3quran.net/afs/067.mp3",
          releaseDate: "02 Jul 2026",
          topic: "Grave Protection",
        ),
      ],
    ),
    PodcastShow(
      id: "heart_therapy",
      title: "Heart Therapy: Purification of Soul",
      speaker: "Dr. Haifaa Younis & Jannah Institute",
      description:
          "Transformative spiritual medicine focusing on Tazkiyah, healing broken hearts, purifying intentions (Ikhlas), and closeness to Allah.",
      category: "Heart Therapy",
      icon: "🕊️",
      rating: 4.97,
      episodes: [
        PodcastEpisode(
          id: "ep_ht_anxiety",
          showId: "heart_therapy",
          showTitle: "Heart Therapy: Purification of Soul",
          speaker: "Dr. Haifaa Younis",
          title: "Healing Spiritual Anxiety & Finding Inner Peace (Sakeenah)",
          description:
              "Practical prophetic tools to transform overwhelming thoughts into profound tranquility through Dhikr, Istighfar, and Tawakkul.",
          duration: "28:10",
          estimatedDuration: Duration(minutes: 28, seconds: 10),
          audioUrl: "https://server11.mp3quran.net/sds/001.mp3",
          releaseDate: "14 Aug 2026",
          topic: "Sakeenah & Solace",
        ),
        PodcastEpisode(
          id: "ep_ht_tahajjud",
          showId: "heart_therapy",
          showTitle: "Heart Therapy: Purification of Soul",
          speaker: "Dr. Haifaa Younis",
          title: "The Sweetness of Tahajjud: Midnight Conversations",
          description:
              "How the last third of the night changes destinies, melts hard hearts, and unlocks miraculous answers to Duas.",
          duration: "31:45",
          estimatedDuration: Duration(minutes: 31, seconds: 45),
          audioUrl: "https://server11.mp3quran.net/sds/067.mp3",
          releaseDate: "08 Aug 2026",
          topic: "Qiyam al-Layl",
        ),
        PodcastEpisode(
          id: "ep_ht_tawbah",
          showId: "heart_therapy",
          showTitle: "Heart Therapy: Purification of Soul",
          speaker: "Dr. Haifaa Younis",
          title: "Sincere Repentance (Tawbah): Coming Home to Allah",
          description:
              "No sin is greater than Allah's vast mercy. Understand the conditions of sincere repentance and starting with a clean slate.",
          duration: "25:20",
          estimatedDuration: Duration(minutes: 25, seconds: 20),
          audioUrl: "https://server7.mp3quran.net/basit/001.mp3",
          releaseDate: "01 Aug 2026",
          topic: "Forgiveness & Hope",
        ),
        PodcastEpisode(
          id: "ep_ht_tawakkul",
          showId: "heart_therapy",
          showTitle: "Heart Therapy: Purification of Soul",
          speaker: "Dr. Haifaa Younis",
          title: "Tawakkul: Surrendering Control When Plans Crumble",
          description:
              "Tie your camel and trust Allah. Overcoming the illusion of total control and embracing divine destiny with satisfaction (Rida).",
          duration: "29:50",
          estimatedDuration: Duration(minutes: 29, seconds: 50),
          audioUrl: "https://server8.mp3quran.net/afs/019.mp3",
          releaseDate: "20 Jul 2026",
          topic: "Trust in Allah",
        ),
      ],
    ),
    PodcastShow(
      id: "blessed_footsteps",
      title: "Blessed Footsteps: The Prophet's Life",
      speaker: "Dr. Omar Suleiman & Yaqeen Institute",
      description:
          "The definitive narrative biography (Seerah) of Prophet Muhammad ﷺ: his compassion, character, leadership, and enduring legacy.",
      category: "Seerah",
      icon: "🕋",
      rating: 4.99,
      episodes: [
        PodcastEpisode(
          id: "ep_seerah_orphan",
          showId: "blessed_footsteps",
          showTitle: "Blessed Footsteps: The Prophet's Life",
          speaker: "Dr. Omar Suleiman",
          title: "The Orphan Who Changed the World: Youth in Makkah",
          description:
              "The birth of Muhammad ﷺ, being raised by Halimah, and his reputation as As-Sadiq Al-Amin (The Truthful, The Trustworthy).",
          duration: "35:10",
          estimatedDuration: Duration(minutes: 35, seconds: 10),
          audioUrl: "https://server8.mp3quran.net/afs/036.mp3",
          releaseDate: "16 Aug 2026",
          topic: "Early Childhood",
        ),
        PodcastEpisode(
          id: "ep_seerah_cave",
          showId: "blessed_footsteps",
          showTitle: "Blessed Footsteps: The Prophet's Life",
          speaker: "Dr. Omar Suleiman",
          title: "The Cave of Hira: Iqra and the First Light of Revelation",
          description:
              "The momentous encounter between Jibreel (AS) and the Prophet ﷺ in the dark of night that transformed human history.",
          duration: "38:40",
          estimatedDuration: Duration(minutes: 38, seconds: 40),
          audioUrl: "https://server8.mp3quran.net/afs/056.mp3",
          releaseDate: "09 Aug 2026",
          topic: "First Revelation",
        ),
        PodcastEpisode(
          id: "ep_seerah_isra",
          showId: "blessed_footsteps",
          showTitle: "Blessed Footsteps: The Prophet's Life",
          speaker: "Dr. Omar Suleiman",
          title: "Al-Isra' wal-Mi'raj: Journey Beyond the Heavens",
          description:
              "Following the Year of Sorrow, Allah honors His Beloved ﷺ with a journey through the seven heavens to the Sidrat al-Muntaha.",
          duration: "44:00",
          estimatedDuration: Duration(minutes: 44, seconds: 0),
          audioUrl: "https://server7.mp3quran.net/basit/055.mp3",
          releaseDate: "03 Aug 2026",
          topic: "Night Ascension",
        ),
        PodcastEpisode(
          id: "ep_seerah_hijrah",
          showId: "blessed_footsteps",
          showTitle: "Blessed Footsteps: The Prophet's Life",
          speaker: "Dr. Omar Suleiman",
          title: "The Hijrah to Madinah: The Brotherhood of Faith",
          description:
              "Escaping assassination in Makkah, the Cave of Thawr, and building the first Islamic community based on justice and love.",
          duration: "41:30",
          estimatedDuration: Duration(minutes: 41, seconds: 30),
          audioUrl: "https://server8.mp3quran.net/afs/002.mp3",
          releaseDate: "24 Jul 2026",
          topic: "The Great Migration",
        ),
      ],
    ),
    PodcastShow(
      id: "jewels_of_wisdom",
      title: "Jewels of Wisdom: Reminders for Life",
      speaker: "Mufti Menk",
      description:
          "Uplifting and relatable spiritual advice for daily challenges, emotional well-being, marriage, and strengthening faith in modern society.",
      category: "Contemporary",
      icon: "💎",
      rating: 4.96,
      episodes: [
        PodcastEpisode(
          id: "ep_mm_tongue",
          showId: "jewels_of_wisdom",
          showTitle: "Jewels of Wisdom: Reminders for Life",
          speaker: "Mufti Menk",
          title: "The Power of Your Tongue: Healing vs Destroying",
          description:
              "A powerful discourse on how kind words build palaces in Jannah, while gossip, slander, and anger ruin years of good deeds.",
          duration: "23:50",
          estimatedDuration: Duration(minutes: 23, seconds: 50),
          audioUrl: "https://server8.mp3quran.net/afs/001.mp3",
          releaseDate: "11 Aug 2026",
          topic: "Guarding Speech",
        ),
        PodcastEpisode(
          id: "ep_mm_barakah",
          showId: "jewels_of_wisdom",
          showTitle: "Jewels of Wisdom: Reminders for Life",
          speaker: "Mufti Menk",
          title: "Finding Barakah: Why Wealth Without Peace Is Empty",
          description:
              "The secret recipe for attracting divine blessings into your morning hours, food, children, and income through gratitude and Sadaqah.",
          duration: "27:15",
          estimatedDuration: Duration(minutes: 27, seconds: 15),
          audioUrl: "https://server8.mp3quran.net/afs/018.mp3",
          releaseDate: "04 Aug 2026",
          topic: "Divine Abundance",
        ),
        PodcastEpisode(
          id: "ep_mm_family",
          showId: "jewels_of_wisdom",
          showTitle: "Jewels of Wisdom: Reminders for Life",
          speaker: "Mufti Menk",
          title: "Mercy in the Home: The Sunnah of Healthy Marriage",
          description:
              "Practical guidance on mutual respect, listening, emotional intelligence, and resolving domestic conflicts with tenderness.",
          duration: "30:40",
          estimatedDuration: Duration(minutes: 30, seconds: 40),
          audioUrl: "https://server8.mp3quran.net/afs/012.mp3",
          releaseDate: "27 Jul 2026",
          topic: "Family & Marriage",
        ),
      ],
    ),
    PodcastShow(
      id: "youth_and_faith",
      title: "Unshakable Faith: Youth & Identity",
      speaker: "Dr. Bilal Philips & Ustadh AbdelRahman",
      description:
          "Guiding the next generation through digital distractions, peer pressure, intellectual doubts, and building a confident Islamic identity.",
      category: "Youth & Family",
      icon: "🌟",
      rating: 4.95,
      episodes: [
        PodcastEpisode(
          id: "ep_yf_identity",
          showId: "youth_and_faith",
          showTitle: "Unshakable Faith: Youth & Identity",
          speaker: "Dr. Bilal Philips",
          title: "Proud to Be Muslim: Standing Tall in School & Work",
          description:
              "Overcoming social anxiety, maintaining prayer at the workplace/university, and turning differences into an opportunity for Dawah.",
          duration: "26:20",
          estimatedDuration: Duration(minutes: 26, seconds: 20),
          audioUrl: "https://server8.mp3quran.net/afs/067.mp3",
          releaseDate: "13 Aug 2026",
          topic: "Muslim Identity",
        ),
        PodcastEpisode(
          id: "ep_yf_screen",
          showId: "youth_and_faith",
          showTitle: "Unshakable Faith: Youth & Identity",
          speaker: "Ustadh AbdelRahman",
          title: "Screen Addiction & Mind Purification: The Digital Fast",
          description:
              "How mindless scrolling steals Barakah, dulls the Quran's sweetness, and practical habits to reclaim focus for the Akhirah.",
          duration: "24:50",
          estimatedDuration: Duration(minutes: 24, seconds: 50),
          audioUrl: "https://server8.mp3quran.net/afs/055.mp3",
          releaseDate: "06 Aug 2026",
          topic: "Digital Detox",
        ),
      ],
    ),
  ];

  static List<PodcastEpisode> get allEpisodes {
    final list = <PodcastEpisode>[];
    for (final show in shows) {
      list.addAll(show.episodes);
    }
    return list;
  }
}
