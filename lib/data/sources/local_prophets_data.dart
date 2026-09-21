import '../models/prophet_model.dart';

class LocalProphetsData {
  static const List<ProphetItem> allProphets = [
    // 1. ADAM (AS)
    ProphetItem(
      order: 1,
      id: "adam",
      nameEnglish: "Adam",
      nameArabic: "آدَم عَلَيْهِ ٱلسَّلَامُ",
      title: "Abu al-Bashar (Father of Humanity)",
      era: "Beginning of Creation",
      quranMentions: 25,
      keySurahs: "Al-Baqarah, Al-A'raf, Ta-Ha",
      historicalLocation: "Earth (Jannat al-Khuld to Earth)",
      miracles: [
        "Created directly by Allah's hands from clay",
        "Taught the names of all things by Allah",
        "Angels commanded to prostrate to him in respect",
      ],
      summary:
          "The first human being and first prophet created by Allah. Allah taught him the names of all things, gave him intellect, and settled him with Hawwa in Paradise before testing them on Earth as vicegerents (Khulafa).",
      milestones: [
        ProphetMilestone(
          title: "The Creation of Adam",
          description:
              "Allah shaped Adam from clay and breathed into him the spirit. Allah taught him the names of all things and asked the angels to prostrate to him. All bowed except Iblis who refused out of pride and arrogance.",
          quranReference: "Surah Al-Baqarah 2:30-34",
        ),
        ProphetMilestone(
          title: "The Test in Paradise",
          description:
              "Adam and his wife Hawwa were permitted to enjoy all fruits of Jannah except one forbidden tree. Iblis whispered deceitful promises to them, causing them to eat from it.",
          quranReference: "Surah Al-A'raf 7:19-22",
        ),
        ProphetMilestone(
          title: "Repentance and Forgiveness",
          description:
              "Realizing their error, Adam and Hawwa did not make excuses or show pride. They turned to Allah with sincere repentance and words of supplication. Allah accepted their repentance and guided them.",
          quranReference: "Surah Al-Baqarah 2:37",
        ),
      ],
      keyDuaArabic:
          "رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ",
      keyDuaTransliteration:
          "Rabbana zalamna anfusana wa in lam taghfir lana wa tarhamna lana-koonanna minal-khasireen.",
      keyDuaEnglish:
          "“Our Lord! We have wronged ourselves, and if You do not forgive us and have mercy upon us, we will surely be among the losers.”",
      keyDuaReference: "Surah Al-A'raf (7:23)",
      moralLessons: [
        "Mistakes do not define you; sincere repentance (Tawbah) elevates you.",
        "Arrogance destroys (like Iblis), while humility and admission of fault bring divine mercy.",
        "Knowledge and intellect are humanity's greatest gifts from Allah.",
      ],
    ),

    // 2. IDRIS (AS)
    ProphetItem(
      order: 2,
      id: "idris",
      nameEnglish: "Idris (Enoch)",
      nameArabic: "إِدْرِيس عَلَيْهِ ٱلسَّلَامُ",
      title: "As-Siddiq (The Truthful & Elevated)",
      era: "Early Humanity (Between Adam & Nuh)",
      quranMentions: 2,
      keySurahs: "Maryam, Al-Anbiya",
      historicalLocation: "Babylon & Ancient Egypt",
      miracles: [
        "First to write with a pen and teach systematic knowledge",
        "Elevated to a high station in the heavens",
        "Early pioneer of tailoring and astronomy in divine service",
      ],
      summary:
          "A prophet renowned for his truthfulness, patience, devotion to knowledge, and invention of writing with the pen. Allah raised him to a high, exalted spiritual station.",
      milestones: [
        ProphetMilestone(
          title: "The Pioneer of Knowledge & Writing",
          description:
              "Idris (AS) was blessed with deep wisdom and was among the first to introduce writing with a pen, mathematics, and astronomy in worship of the Creator.",
          quranReference: "Surah Maryam 19:56",
        ),
        ProphetMilestone(
          title: "Raised to a High Station",
          description:
              "Allah says: 'And We raised him to a high station.' During the Isra' and Mi'raj, Prophet Muhammad ﷺ met Prophet Idris in the fourth heaven.",
          quranReference: "Surah Maryam 19:57",
        ),
      ],
      keyDuaArabic: "سُبْحَانَ اللَّهِ الْعَظِيمِ وَبِحَمْدِهِ",
      keyDuaTransliteration: "Subhan Allahil-'Azeemi wa bihamdih.",
      keyDuaEnglish:
          "“Glory be to Allah, the Magnificent, and praise be to Him.”",
      keyDuaReference: "Prophetic Sunnah & Dhikr",
      moralLessons: [
        "Knowledge and craftsmanship are noble forms of worship when used for good.",
        "Truthfulness and perseverance raise a servant in rank before Allah.",
      ],
    ),

    // 3. NUH (AS)
    ProphetItem(
      order: 3,
      id: "nuh",
      nameEnglish: "Nuh (Noah)",
      nameArabic: "نُوح عَلَيْهِ ٱلسَّلَامُ",
      title: "Shaykh al-Anbiya (Elder of Prophets / First Messenger)",
      era: "Pre-Diluvian Era",
      quranMentions: 43,
      keySurahs: "Surah Nuh, Hud, Al-Mu'minun",
      historicalLocation: "Mesopotamia (Iraq / Mount Judi)",
      miracles: [
        "Building the Ark under divine inspiration without prior naval knowledge",
        "Survival of believers and pairs of all creatures through the Great Deluge",
        "The Ark coming to rest safely on Mount Judi",
      ],
      summary:
          "One of the five greatest messengers of resolve (Ulu al-Azm). He called his idol-worshipping people day and night for 950 years with boundless patience before Allah sent the purifying Great Flood.",
      milestones: [
        ProphetMilestone(
          title: "950 Years of Relentless Da'wah",
          description:
              "Nuh called his people night and day, publicly and privately, enduring relentless mockery, slander, and insults from the wealthy and arrogant elite.",
          quranReference: "Surah Nuh 71:5-9",
        ),
        ProphetMilestone(
          title: "Building the Ark on Dry Land",
          description:
              "Allah instructed Nuh to construct the gigantic Ark. His people passed by him laughing and mocking him for building a ship in the middle of a desert.",
          quranReference: "Surah Hud 11:37-38",
        ),
        ProphetMilestone(
          title: "The Great Flood & The Parting of his Son",
          description:
              "The fountains of the earth burst and the skies opened with torrential rain. Nuh called out to his disbelieving son who sought refuge on a mountain, but the waves separated them.",
          quranReference: "Surah Hud 11:42-44",
        ),
      ],
      keyDuaArabic:
          "رَّبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِمَن دَخَلَ بَيْتِيَ مُؤْمِنًا وَلِلْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ",
      keyDuaTransliteration:
          "Rabbi-ghfir lee wa li-walidayya wa liman dakhala baytiya mu'minan wa lil-mu'mineena wal-mu'minat.",
      keyDuaEnglish:
          "“My Lord! Forgive me, my parents, whoever enters my home as a believer, and all believing men and believing women.”",
      keyDuaReference: "Surah Nuh (71:28)",
      moralLessons: [
        "Patience and steadfastness in calling to truth, regardless of how long it takes.",
        "Faith and obedience to Allah transcend blood relations; salvation is through personal faith.",
        "Trust in Allah's promise even when everyone around you ridicules you.",
      ],
    ),

    // 4. HUD (AS)
    ProphetItem(
      order: 4,
      id: "hud",
      nameEnglish: "Hud",
      nameArabic: "هُود عَلَيْهِ ٱلسَّلَامُ",
      title: "Prophet to the Mighty People of 'Ad",
      era: "Post-Flood Ancient Arabia",
      quranMentions: 7,
      keySurahs: "Surah Hud, Al-Ahqaf, Ash-Shu'ara",
      historicalLocation: "Al-Ahqaf (Sand Dunes of Southern Arabia / Yemen)",
      miracles: [
        "Protected from the physical violence of giant tyrants",
        "Prophesied the barren cold windstorm that destroyed 'Ad while sparing believers",
      ],
      summary:
          "Sent to the prosperous, physically giant people of 'Ad who built towering monuments (Iram) and boasted: 'Who is greater than us in strength?' Hud warned them against tyranny and called them to Monotheism.",
      milestones: [
        ProphetMilestone(
          title: "Warning the Giants of 'Ad",
          description:
              "Hud reminded 'Ad of Allah's blessings of physical strength and architectural mastery, calling them to stop oppressing the weak and worship Allah alone.",
          quranReference: "Surah Al-Ahqaf 46:21-23",
        ),
        ProphetMilestone(
          title: "The Fierce Seven-Night Wind",
          description:
              "When 'Ad saw a cloud approaching, they thought it was rain. It was a freezing, destructive wind (Sarsar) that blew for seven nights and eight days, leaving them like hollow palm trunks.",
          quranReference: "Surah Al-Haqqah 69:6-7",
        ),
      ],
      keyDuaArabic:
          "إِنِّي تَوَكَّلْتُ عَلَى اللَّهِ رَبِّي وَرَبِّكُم ۚ مَّا مِن دَابَّةٍ إِلَّا هُوَ آخِذٌ بِنَاصِيَتِهَا",
      keyDuaTransliteration:
          "Innee tawakkaltu 'alallahi Rabbee wa Rabbikum; ma min daabbatin illa Huwa akhizum bi-nasiyatiha.",
      keyDuaEnglish:
          "“Indeed, I have put my trust in Allah, my Lord and your Lord. There is no creature but that He holds its forelock.”",
      keyDuaReference: "Surah Hud (11:56)",
      moralLessons: [
        "Physical strength and technological grandeur cannot protect against divine justice.",
        "Putting total trust (Tawakkul) in Allah gives courage in the face of arrogant tyrants.",
      ],
    ),

    // 5. SALEH (AS)
    ProphetItem(
      order: 5,
      id: "saleh",
      nameEnglish: "Saleh",
      nameArabic: "صَالِح عَلَيْهِ ٱلسَّلَامُ",
      title: "Prophet to Thamud & Guardian of the She-Camel",
      era: "Ancient Arabia",
      quranMentions: 9,
      keySurahs: "Al-A'raf, Hud, Ash-Shu'ara, Al-Qamar",
      historicalLocation: "Al-Hijr / Mada'in Saleh (Northwest Arabia)",
      miracles: [
        "The She-Camel of Allah (*Naqatullah*) emerging alive from a solid rock",
        "The She-Camel producing milk sufficient for the entire population",
      ],
      summary:
          "Sent to Thamud, who carved magnificent homes into mountains. When they demanded a miraculous she-camel emerge from a boulder, Allah granted it as a sign. When they slaughtered her, a terrible blast destroyed them.",
      milestones: [
        ProphetMilestone(
          title: "The Miraculous She-Camel",
          description:
              "Allah brought forth a unique she-camel from a rock with designated drinking days. Saleh warned: 'Touch her not with harm, lest a painful punishment seize you.'",
          quranReference: "Surah Ash-Shams 91:11-13",
        ),
        ProphetMilestone(
          title: "The Transgression and the Blast",
          description:
              "Corrupt leaders conspired and hamstrung the she-camel. After three days of warning, an earth-shattering sound and quake (*Sayhah*) destroyed their civilization.",
          quranReference: "Surah Hud 11:65-68",
        ),
      ],
      keyDuaArabic:
          "يَا قَوْمِ اعْبُدُوا اللَّهَ مَا لَكُم مِّنْ إِلَٰهٍ غَيْرُهُ",
      keyDuaTransliteration:
          "Ya qawmi'budullaha ma lakum min ilahin ghayruh.",
      keyDuaEnglish:
          "“O my people! Worship Allah; you have no deity other than Him.”",
      keyDuaReference: "Surah Al-A'raf (7:73)",
      moralLessons: [
        "Respect the sacred boundaries set by Allah.",
        "A few corrupt individuals can lead an entire silent community to ruin if not corrected.",
      ],
    ),

    // 6. IBRAHIM (AS)
    ProphetItem(
      order: 6,
      id: "ibrahim",
      nameEnglish: "Ibrahim (Abraham)",
      nameArabic: "إِبْرَاهِيم عَلَيْهِ ٱلسَّلَامُ",
      title: "Khalilullah (Friend of Allah) & Father of Prophets",
      era: "Patriarchal Era (~2000 BCE)",
      quranMentions: 69,
      keySurahs: "Surah Ibrahim, Al-Baqarah, Al-Anbiya, As-Saffat",
      historicalLocation: "Ur (Iraq), Babylon, Canaan (Palestine), Makkah",
      miracles: [
        "The blazing furnace of Nimrod made cool and safe (*Bardan wa Salama*)",
        "Revival of four birds after cutting them and placing them on mountains",
        "Building the Holy Kaaba and instituting the sacred Hajj pilgrimage",
        "Spurting of the Well of Zamzam for Ismail and Hajar",
      ],
      summary:
          "One of the greatest messengers of resolve and leader of mankind (*Imam an-Nas*). He shattered idols, survived Nimrod's fire, proved absolute submission in the sacrifice test, and built the Kaaba with Ismail.",
      milestones: [
        ProphetMilestone(
          title: "Challenging Idolatry & Surviving the Fire",
          description:
              "Ibrahim broke the idols of his city to show their helplessness. King Nimrod cast him into a roaring fire, but Allah commanded: 'O fire, be coolness and safety for Ibrahim!'",
          quranReference: "Surah Al-Anbiya 21:68-70",
        ),
        ProphetMilestone(
          title: "Settling in the Barren Valley of Makkah",
          description:
              "Out of obedience to Allah, Ibrahim left his wife Hajar and infant Ismail in the barren desert of Makkah. Hajar ran between Safa and Marwah, and the spring of Zamzam burst forth.",
          quranReference: "Surah Ibrahim 14:37",
        ),
        ProphetMilestone(
          title: "The Ultimate Sacrifice & Building the Kaaba",
          description:
              "Tested in a dream to sacrifice his beloved son Ismail, both father and son submitted completely. Allah ransomed Ismail with a great ram and commanded them to build the Kaaba.",
          quranReference: "Surah As-Saffat 37:102-108, Al-Baqarah 2:127",
        ),
      ],
      keyDuaArabic:
          "رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِن ذُرِّيَّتِي ۚ رَبَّنَا وَتَقَبَّلْ دُعَاءِ",
      keyDuaTransliteration:
          "Rabbij'alnee muqeemas-Salati wa min dhurriyyatee; Rabbana wa taqabbal du'aa.",
      keyDuaEnglish:
          "“My Lord, make me an establisher of prayer, and [many] from my descendants. Our Lord, and accept my supplication.”",
      keyDuaReference: "Surah Ibrahim (14:40)",
      moralLessons: [
        "True faith (Iman) means pure monotheism and complete surrender to Allah's will.",
        "Allah never abandons those who sacrifice worldly desires for His pleasure.",
        "The legacy of righteousness is preserved through sincere prayer for one's children.",
      ],
    ),

    // 7. LUT (AS)
    ProphetItem(
      order: 7,
      id: "lut",
      nameEnglish: "Lut (Lot)",
      nameArabic: "لُوط عَلَيْهِ ٱلسَّلَامُ",
      title: "Messenger to Sodom & Gomorrah",
      era: "Contemporary of Ibrahim (AS)",
      quranMentions: 27,
      keySurahs: "Hud, Al-Hijr, Ash-Shu'ara, Al-Anbiya",
      historicalLocation: "Sodom & Gomorrah (Dead Sea Region)",
      miracles: [
        "Protected from the unruly mob by the angels Jibril and Mikail",
        "Spared with the believers while a rain of baked stones destroyed the corrupt city",
      ],
      summary:
          "Nephew of Ibrahim (AS) sent to the people of Sodom who practiced open shamelessness, highway robbery, and unnatural desires. He patiently warned them until divine angels delivered the punishment.",
      milestones: [
        ProphetMilestone(
          title: "Calling to Purity & Natural Order",
          description:
              "Lut confronted his people about their unprecedented transgression and rejection of modesty, urging them to fear Allah and seek pure marriages.",
          quranReference: "Surah Ash-Shu'ara 26:160-166",
        ),
        ProphetMilestone(
          title: "The Arrival of the Angelic Guests",
          description:
              "Angels appeared in the form of handsome guests. When the mob surrounded Lut's house, Jibril blinded them and instructed Lut to leave by night.",
          quranReference: "Surah Hud 11:77-81",
        ),
      ],
      keyDuaArabic:
          "رَبِّ نَجِّنِي وَأَهْلِي مِمَّا يَعْمَلُونَ",
      keyDuaTransliteration:
          "Rabbi najjinee wa ahlee mimma ya'maloon.",
      keyDuaEnglish:
          "“My Lord, save me and my family from what they do.”",
      keyDuaReference: "Surah Ash-Shu'ara (26:169)",
      moralLessons: [
        "Standing firm for moral purity even when the entire society normalizes corruption.",
        "Personal closeness to a prophet (like Lut's disbelieving wife) cannot save one who rejects faith.",
      ],
    ),

    // 8. ISMAIL (AS)
    ProphetItem(
      order: 8,
      id: "ismail",
      nameEnglish: "Ismail (Ishmael)",
      nameArabic: "إِسْمَاعِيل عَلَيْهِ ٱلسَّلَامُ",
      title: "Dhabihullah (The Sacrificed) & Ancestor of Prophet Muhammad ﷺ",
      era: "Patriarchal Era",
      quranMentions: 12,
      keySurahs: "Al-Baqarah, Maryam, As-Saffat",
      historicalLocation: "Makkah (Hijaz)",
      miracles: [
        "The Spring of Zamzam gushing beneath his infant heels",
        "Ransomed by a ram from heaven during the sacrifice test",
        "Co-builder of the Holy Kaaba with his father Ibrahim",
      ],
      summary:
          "The firstborn son of Ibrahim (AS) and Hajar. Known for his supreme obedience (*Sadiq al-Wa'd*), he willingly submitted to the divine command of sacrifice and assisted in erecting the Holy Kaaba.",
      milestones: [
        ProphetMilestone(
          title: "The Gushing of Zamzam",
          description:
              "As an infant left in Makkah, his mother ran between Safa and Marwah seeking water. Angel Jibril struck the earth, and pure Zamzam water gushed forth.",
          quranReference: "Sahih Al-Bukhari 3364",
        ),
        ProphetMilestone(
          title: "The Willing Sacrifice",
          description:
              "When his father informed him of the vision of sacrifice, young Ismail replied: 'O my father, do as you are commanded; you will find me, if Allah wills, of the patient.'",
          quranReference: "Surah As-Saffat 37:102",
        ),
      ],
      keyDuaArabic:
          "رَبَّنَا تَقَبَّلْ مِنَّا ۖ إِنَّكَ أَنتَ السَّمِيعُ الْعَلِيمُ",
      keyDuaTransliteration:
          "Rabbana taqabbal minna; innaka Antas-Samee'ul-'Aleem.",
      keyDuaEnglish:
          "“Our Lord! Accept [this] from us. Indeed, You are the Hearing, the Knowing.”",
      keyDuaReference: "Surah Al-Baqarah (2:127)",
      moralLessons: [
        "Exemplary obedience and respect towards righteous parents.",
        "Humility in worship—always asking Allah to accept our righteous deeds.",
      ],
    ),

    // 9. ISHAQ (AS)
    ProphetItem(
      order: 9,
      id: "ishaq",
      nameEnglish: "Ishaq (Isaac)",
      nameArabic: "إِسْحَاق عَلَيْهِ ٱلسَّلَامُ",
      title: "The Blessed Son of Ibrahim & Sarah",
      era: "Patriarchal Era",
      quranMentions: 17,
      keySurahs: "Al-Baqarah, As-Saffat, Yusuf, Sad",
      historicalLocation: "Canaan / Hebron (Palestine)",
      miracles: [
        "Born miraculously to elderly parents (Ibrahim & Sarah)",
        "Father of Yaqub (Israel) and ancestor of the Banu Israel prophets",
      ],
      summary:
          "The righteous second son of Ibrahim (AS), granted to Sarah in her old age as glad tidings from angels. A pious leader who passed down divine guidance in the land of Canaan.",
      milestones: [
        ProphetMilestone(
          title: "Glad Tidings to Sarah",
          description:
              "Angels visited Ibrahim and gave glad tidings of a knowledgeable boy, Ishaq, and after him Yaqub. Sarah laughed in astonishment, but the angels reminded her: 'Is it surprising by the decree of Allah?'",
          quranReference: "Surah Hud 11:71-73",
        ),
      ],
      keyDuaArabic:
          "الْحَمْدُ لِلَّهِ الَّذِي وَهَبَ لِي عَلَى الْكِبَرِ إِسْمَاعِيلَ وَإِسْحَاقَ",
      keyDuaTransliteration:
          "Alhamdu lillahilladhee wahaba lee 'alal-kibari Isma'eela wa Ishaq.",
      keyDuaEnglish:
          "“Praise be to Allah, who has granted to me in old age Ismail and Ishaq.”",
      keyDuaReference: "Surah Ibrahim (14:39)",
      moralLessons: [
        "Nothing is impossible for Allah; divine gifts arrive at the perfect ordained time.",
        "Steadfastness in righteousness preserves family blessings across generations.",
      ],
    ),

    // 10. YAQUB (AS)
    ProphetItem(
      order: 10,
      id: "yaqub",
      nameEnglish: "Yaqub (Jacob / Israel)",
      nameArabic: "يَعْقُوب عَلَيْهِ ٱلسَّلَامُ",
      title: "Israel (Servant of God) & Master of Beautiful Patience",
      era: "Patriarchal Era",
      quranMentions: 16,
      keySurahs: "Surah Yusuf, Al-Baqarah, Maryam",
      historicalLocation: "Canaan (Palestine) to Egypt",
      miracles: [
        "Regaining eyesight when the shirt of Yusuf was cast over his face",
        "Deep spiritual intuition and knowledge of dreams",
      ],
      summary:
          "Son of Ishaq and father of the twelve tribes of Israel, including Prophet Yusuf. Renowned for his *Sabrun Jameel* (beautiful, dignified patience) when separated from his beloved son for decades.",
      milestones: [
        ProphetMilestone(
          title: "The Grief for Yusuf",
          description:
              "When his sons brought Yusuf's shirt stained with false blood, Yaqub declared: 'Rather, your souls have enticed you to something, so patience is most fitting (*Fa Sabrun Jameel*).'",
          quranReference: "Surah Yusuf 12:18",
        ),
        ProphetMilestone(
          title: "Restoration of Sight and Family Reunion",
          description:
              "After years of weeping until his eyes grew white with grief, Yusuf's shirt was placed upon his face, restoring his sight, and the family reunited in Egypt prostrating in gratitude.",
          quranReference: "Surah Yusuf 12:96-100",
        ),
      ],
      keyDuaArabic:
          "إِنَّمَا أَشْكُو بَثِّي وَحُزْنِي إِلَى اللَّهِ وَأَعْلَمُ مِنَ اللَّهِ مَا لَا تَعْلَمُونَ",
      keyDuaTransliteration:
          "Innama ashkoo baththee wa huznee ilallah, wa a'lamu minallahi ma la ta'lamoon.",
      keyDuaEnglish:
          "“I only complain of my suffering and my grief to Allah, and I know from Allah that which you do not know.”",
      keyDuaReference: "Surah Yusuf (12:86)",
      moralLessons: [
        "Direct your sorrows, anxieties, and grief only to Allah, not to people.",
        "Never lose hope in Allah's mercy, even after decades of hardship.",
      ],
    ),

    // 11. YUSUF (AS)
    ProphetItem(
      order: 11,
      id: "yusuf",
      nameEnglish: "Yusuf (Joseph)",
      nameArabic: "يُوسُف عَلَيْهِ ٱلسَّلَامُ",
      title: "As-Siddiq (The Truthful) & Prince of Beauty and Integrity",
      era: "Middle Bronze Age (~1700 BCE)",
      quranMentions: 27,
      keySurahs: "Surah Yusuf (Ahsan al-Qasas - The Best of Stories)",
      historicalLocation: "Canaan to Egypt",
      miracles: [
        "Divine gift of dream interpretation (*Ta'weel al-Ahadith*)",
        "Blessed with extraordinary physical and spiritual beauty",
        "His shirt healing his father's blindness",
      ],
      summary:
          "The son of Yaqub who was thrown into a well by jealous brothers, sold into slavery in Egypt, falsely imprisoned for resisting seduction, and rose through divine wisdom to become Minister of Finance.",
      milestones: [
        ProphetMilestone(
          title: "From the Well to the Minister's Palace",
          description:
              "Cast into a dark well by his brothers, Yusuf was picked up by a caravan and sold to the Aziz of Egypt, where he grew into righteous maturity.",
          quranReference: "Surah Yusuf 12:19-21",
        ),
        ProphetMilestone(
          title: "Preserving Chastity & Prison",
          description:
              "When the Aziz's wife attempted to seduce him, Yusuf fled, seeking Allah's protection. Preferring prison over sin, he was unjustly jailed where he taught Tawheed to inmates.",
          quranReference: "Surah Yusuf 12:33",
        ),
        ProphetMilestone(
          title: "Interpreting the King's Dream & Forgiving his Brothers",
          description:
              "Yusuf accurately interpreted the king's dream of seven lean cows devouring seven fat ones. Released and appointed Minister, he saved Egypt from famine and forgave his brothers completely.",
          quranReference: "Surah Yusuf 12:54-56, 92",
        ),
      ],
      keyDuaArabic:
          "فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ أَنتَ وَلِيِّي فِي الدُّنْيَا وَالْآخِرَةِ ۖ تَوَفَّنِي مُسْلِمًا وَأَلْحِقْنِي بِالصَّالِحِينَ",
      keyDuaTransliteration:
          "Fatiras-samawati wal-ardi Anta Waliyyee fid-dunya wal-akhirah; tawaffanee musliman wa alhiqnee bis-saliheen.",
      keyDuaEnglish:
          "“Creator of the heavens and earth! You are my Protector in this world and in the Hereafter. Cause me to die a Muslim and join me with the righteous.”",
      keyDuaReference: "Surah Yusuf (12:101)",
      moralLessons: [
        "Chastity and fear of Allah in private bring honor and elevation in public.",
        "Forgiveness is the supreme mark of nobility (*La tathreeba 'alaykumul-yawm*).",
        "Allah's divine plan works subtly through apparent tragedies to bring triumph.",
      ],
    ),

    // 12. AYYUB (AS)
    ProphetItem(
      order: 12,
      id: "ayyub",
      nameEnglish: "Ayyub (Job)",
      nameArabic: "أَيُّوب عَلَيْهِ ٱلسَّلَامُ",
      title: "Sayyid as-Sabireen (Master of Patient Endurers)",
      era: "Patriarchal Era",
      quranMentions: 4,
      keySurahs: "Al-Anbiya, Sad",
      historicalLocation: "Hauran / Levant (Syria)",
      miracles: [
        "A cool miraculous spring bursting from the ground that healed all his illnesses",
        "Restoration of his family, health, and wealth twofold by divine grace",
      ],
      summary:
          "A wealthy and righteous prophet who lost all his wealth, his children, and his physical health to a severe illness lasting many years. He never complained against Allah and was fully restored.",
      milestones: [
        ProphetMilestone(
          title: "The Supreme Trial of Health and Wealth",
          description:
              "Ayyub was tested with the loss of his property, children, and severe bodily affliction. His tongue remained continuously engaged in praising Allah.",
          quranReference: "Surah Sad 38:41",
        ),
        ProphetMilestone(
          title: "The Healing Spring",
          description:
              "Allah commanded him: 'Strike the ground with your foot; here is a cool bath and drinking water.' His youth, health, and family were restored.",
          quranReference: "Surah Sad 38:42-43",
        ),
      ],
      keyDuaArabic:
          "أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ",
      keyDuaTransliteration:
          "Annee massaniyad-durru wa Anta Arhamur-Rahimeen.",
      keyDuaEnglish:
          "“Indeed, adversity has touched me, and You are the Most Merciful of the merciful.”",
      keyDuaReference: "Surah Al-Anbiya (21:83)",
      moralLessons: [
        "Patience during severe illness and loss earns unmatched divine reward.",
        "Framing distress with courtesy and reverence toward Allah in supplication.",
      ],
    ),

    // 13. SHU'AYB (AS)
    ProphetItem(
      order: 13,
      id: "shuayb",
      nameEnglish: "Shu'ayb (Jethro)",
      nameArabic: "شُعَيْب عَلَيْهِ ٱلسَّلَامُ",
      title: "Khateeb al-Anbiya (Orator of the Prophets)",
      era: "Ancient Madyan (~1500 BCE)",
      quranMentions: 11,
      keySurahs: "Al-A'raf, Hud, Ash-Shu'ara, Al-Qasas",
      historicalLocation: "Madyan (Northwestern Arabia / Jordan)",
      miracles: [
        "Eloquence of speech and logical refutation of economic corruption",
        "Believers saved while the Day of the Shadow cloud rained fire on corrupt traders",
      ],
      summary:
          "Renowned for his supreme eloquence in debate. He called the people of Madyan and the Companions of the Wood (*Ashab al-Aykah*) to honest business weights and measures, warning against economic extortion.",
      milestones: [
        ProphetMilestone(
          title: "Reforming Business & Ethical Trade",
          description:
              "Shu'ayb urged his people to give full measure and weight, stop cheating people of their possessions, and not spread corruption on earth.",
          quranReference: "Surah Hud 11:84-85",
        ),
      ],
      keyDuaArabic:
          "وَمَا تَوْفِيقِي إِلَّا بِاللَّهِ ۚ عَلَيْهِ تَوَكَّلْتُ وَإِلَيْهِ أُنِيبُ",
      keyDuaTransliteration:
          "Wa ma tawfeeqee illa billah; 'alayhi tawakkaltu wa ilayhi uneeb.",
      keyDuaEnglish:
          "“And my success is not but through Allah. Upon Him I have relied, and to Him I return.”",
      keyDuaReference: "Surah Hud (11:88)",
      moralLessons: [
        "Economic honesty and fair weights are religious obligations in Islam.",
        "Success (*Tawfeeq*) in any noble reform comes solely from Allah.",
      ],
    ),

    // 14. MUSA (AS)
    ProphetItem(
      order: 14,
      id: "musa",
      nameEnglish: "Musa (Moses)",
      nameArabic: "مُوسَىٰ عَلَيْهِ ٱلسَّلَامُ",
      title: "Kalimullah (The One Who Spoke with Allah)",
      era: "Late Bronze Age (~1300 BCE)",
      quranMentions: 136,
      keySurahs: "Al-Baqarah, Al-A'raf, Ta-Ha, Al-Qasas, Ash-Shu'ara",
      historicalLocation: "Egypt, Mount Sinai (Tur), Wilderness of Sinai",
      miracles: [
        "Staff turning into a living serpent swallowing magicians' illusions",
        "Hand glowing with brilliant white light without blemish (*Yadun Bayda*)",
        "Parting of the Red Sea into towering walls of water",
        "Twelve springs gushing from a rock struck with his staff",
        "Direct speech with Allah at Mount Tur (Sinai)",
        "The Torah (*At-Tawrat*) revealed on stone tablets",
      ],
      summary:
          "The most mentioned prophet in the Quran. Placed as an infant in the Nile, raised in Pharaoh's palace, called directly by Allah at the Burning Bush, confronted Pharaoh, parted the sea, and led the children of Israel.",
      milestones: [
        ProphetMilestone(
          title: "Infancy in the River & Pharaoh's Palace",
          description:
              "To save him from Pharaoh's decree of killing baby boys, his mother placed him in a chest in the Nile. Pharaoh's wife Asiya adopted him, and his sister ensured his mother became his wet nurse.",
          quranReference: "Surah Al-Qasas 28:7-13",
        ),
        ProphetMilestone(
          title: "The Burning Bush at Mount Tur",
          description:
              "In the sacred valley of Tuwa, Allah spoke directly to Musa: 'Indeed, I am Allah. There is no deity except Me, so worship Me and establish prayer for My remembrance.'",
          quranReference: "Surah Ta-Ha 20:11-14",
        ),
        ProphetMilestone(
          title: "Confronting Pharaoh & Parting of the Red Sea",
          description:
              "Musa defeated the royal magicians who fell in prostration. Pursued to the Red Sea, Musa struck the water with his staff, opening dry paths. Pharaoh and his army were drowned.",
          quranReference: "Surah Ash-Shu'ara 26:61-66",
        ),
      ],
      keyDuaArabic:
          "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي يَفْقَهُوا قَوْلِي",
      keyDuaTransliteration:
          "Rabbish-rah lee sadree wa yassir lee amree wahlul 'uqdatam-mil-lisanee yafqahoo qawlee.",
      keyDuaEnglish:
          "“My Lord! Expand for me my breast [with confidence], and ease for me my task, and untie the knot from my tongue, that they may understand my speech.”",
      keyDuaReference: "Surah Ta-Ha (20:25-28)",
      moralLessons: [
        "Courage against the world's greatest tyrants is born from closeness to Allah.",
        "Faith transforms helplessness into victory: 'No! Indeed, with me is my Lord; He will guide me.'",
      ],
    ),

    // 15. HARUN (AS)
    ProphetItem(
      order: 15,
      id: "harun",
      nameEnglish: "Harun (Aaron)",
      nameArabic: "هَارُون عَلَيْهِ ٱلسَّلَامُ",
      title: "Wazir al-Haqq (The Eloquent Brother & Helper)",
      era: "Contemporary of Musa (AS)",
      quranMentions: 20,
      keySurahs: "Ta-Ha, Al-A'raf, Maryam, Al-Qasas",
      historicalLocation: "Egypt & Sinai",
      miracles: [
        "Appointed prophet and vizier upon Musa's supplication",
        "Blessed with exceptional eloquence and diplomatic wisdom",
      ],
      summary:
          "Elder brother of Musa (AS), appointed prophet by Allah at Musa's request to be his helper and spokesman. Known for his eloquence, compassion, and steadfastness in preserving monotheism.",
      milestones: [
        ProphetMilestone(
          title: "Appointed as Co-Messenger",
          description:
              "Musa prayed for Harun to share his mission due to his eloquent speech. Allah granted the request, sending both to Pharaoh.",
          quranReference: "Surah Ta-Ha 20:29-36",
        ),
        ProphetMilestone(
          title: "Preserving Unity in the Wilderness",
          description:
              "When Samiri misled the people with the golden calf while Musa was on Mount Sinai, Harun firmly cautioned them against idolatry while preventing civil war.",
          quranReference: "Surah Ta-Ha 20:90-94",
        ),
      ],
      keyDuaArabic:
          "رَبَّنَا لَا تُشْمِتْ بِيَ الْأَعْدَاءَ وَلَا تَجْعَلْنِي مَعَ الْقَوْمِ الظَّالِمِينَ",
      keyDuaTransliteration:
          "Rabbana la tushmit biyal-a'daa-a wa la taj'alnee ma'al-qawmiz-zalimeen.",
      keyDuaEnglish:
          "“Our Lord, do not let the enemies rejoice over me, and do not count me among the wrongdoing people.”",
      keyDuaReference: "Surah Al-A'raf (7:150)",
      moralLessons: [
        "Brotherhood and mutual support in calling people to truth.",
        "Patience and wise leadership during community crises.",
      ],
    ),

    // 16. DHUL-KIFL (AS)
    ProphetItem(
      order: 16,
      id: "dhul-kifl",
      nameEnglish: "Dhul-Kifl (Ezekiel)",
      nameArabic: "ذُو ٱلْكِفْل عَلَيْهِ ٱلسَّلَامُ",
      title: "The Faithful Fulfiller of Pledges",
      era: "Era of the Judges",
      quranMentions: 2,
      keySurahs: "Al-Anbiya, Sad",
      historicalLocation: "Levant / Iraq",
      miracles: [
        "Steadfast devotion: fasting daily, praying through nights, and judging with strict justice without anger",
      ],
      summary:
          "Mentioned alongside Ismail and Idris in the Quran as among the steadfast and righteous. Known for taking upon himself the responsibility of leading people with absolute justice and keeping his word.",
      milestones: [
        ProphetMilestone(
          title: "The Man of the Covenant",
          description:
              "He pledged to lead the people by fasting every day, praying every night, and never giving in to anger while dispensing justice, fulfilling every promise faithfully.",
          quranReference: "Surah Al-Anbiya 21:85-86",
        ),
      ],
      keyDuaArabic:
          "وَأَدْخِلْنَا فِي رَحْمَتِكَ ۖ إِنَّكَ أَنتَ أَرْحَمُ الرَّاحِمِينَ",
      keyDuaTransliteration:
          "Wa adkhilna fee rahmatika; innaka Anta Arhamur-Rahimeen.",
      keyDuaEnglish:
          "“And admit us into Your mercy; indeed, You are the Most Merciful of the merciful.”",
      keyDuaReference: "Quranic Duas of the Righteous",
      moralLessons: [
        "Keeping covenants and promises is a sacred pillar of faith.",
        "Consistency in worship and self-control in positions of power.",
      ],
    ),

    // 17. DAWUD (AS)
    ProphetItem(
      order: 17,
      id: "dawud",
      nameEnglish: "Dawud (David)",
      nameArabic: "دَاوُود عَلَيْهِ ٱلسَّلَامُ",
      title: "The Warrior King & Psalm Singer (Al-Zabur)",
      era: "Kingdom of Israel (~1000 BCE)",
      quranMentions: 16,
      keySurahs: "Al-Baqarah, Al-Anbiya, Saba, Sad",
      historicalLocation: "Jerusalem (Al-Quds)",
      miracles: [
        "Softening of iron in his hands like dough without fire or tools",
        "Mountains and birds echoing his melodious praise of Allah (*Tasbih*)",
        "Defeating Goliath (Jalut) as a young shepherd with a simple sling",
        "The revelation of the Psalms (*Az-Zabur*)",
      ],
      summary:
          "A righteous warrior, just king, and prophet who defeated Goliath. Allah revealed to him the Zabur, softened iron for him to craft armor, and caused mountains and birds to sing praises with him.",
      milestones: [
        ProphetMilestone(
          title: "Slaying Jalut (Goliath)",
          description:
              "When King Talut's army faced the giant Jalut, young Dawud stepped forward with pure faith in Allah and felled Goliath with a single stone from his sling.",
          quranReference: "Surah Al-Baqarah 2:251",
        ),
        ProphetMilestone(
          title: "The Melodious Zabur & Softened Iron",
          description:
              "When Dawud recited the Zabur, birds would stop in mid-air and mountains would resonate in chorus with his praises. Allah softened iron in his hands to weave protective chainmail armor.",
          quranReference: "Surah Saba 34:10-11",
        ),
      ],
      keyDuaArabic:
          "رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا وَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ",
      keyDuaTransliteration:
          "Rabbana afrigh 'alayna sabran wa thabbit aqdamana wansurna 'alal-qawmil-kafireen.",
      keyDuaEnglish:
          "“Our Lord! Pour upon us patience and plant firmly our feet and give us victory over the disbelieving people.”",
      keyDuaReference: "Surah Al-Baqarah (2:250)",
      moralLessons: [
        "True strength lies in faith, not physical size or weapons.",
        "Earning one's living through honest work—the Prophet ﷺ said Dawud only ate from what his own hands earned.",
        "Balancing governance and power with deep, tearful spirituality.",
      ],
    ),

    // 18. SULAYMAN (AS)
    ProphetItem(
      order: 18,
      id: "sulayman",
      nameEnglish: "Sulayman (Solomon)",
      nameArabic: "سُلَيْمَان عَلَيْهِ ٱلسَّلَامُ",
      title: "The Sovereign King & Master of Creation",
      era: "Golden Age of Jerusalem (~960 BCE)",
      quranMentions: 17,
      keySurahs: "Al-Anbiya, An-Naml, Saba, Sad",
      historicalLocation: "Jerusalem (Al-Quds) & Levant",
      miracles: [
        "Understanding the speech of birds, ants, and animals (*Mantiq at-Tayr*)",
        "Control over the wind, traveling a month's journey in morning and evening",
        "Subjugation of the Jinn to build magnificent architecture and dive for pearls",
        "A fountain of molten brass (*Ayn al-Qitr*) flowing for his use",
      ],
      summary:
          "Son of Dawud who inherited his kingdom and wisdom. Granted an unprecedented dominion that none would possess after him, yet remained profoundly humble, grateful, and devout before Allah.",
      milestones: [
        ProphetMilestone(
          title: "The Ant and the Valley",
          description:
              "Marching with his vast armies of men, jinn, and birds, Sulayman heard an ant warning its colony to enter their dwellings lest they be crushed unawares. Sulayman smiled joyfully and thanked Allah.",
          quranReference: "Surah An-Naml 27:18-19",
        ),
        ProphetMilestone(
          title: "The Queen of Sheba (Bilqis)",
          description:
              "Informed by the Hoopoe bird of a queen worshipping the sun in Yemen, Sulayman invited her to Islam. Seeing his miraculous palace of glass over water, she embraced pure monotheism.",
          quranReference: "Surah An-Naml 27:44",
        ),
      ],
      keyDuaArabic:
          "رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ",
      keyDuaTransliteration:
          "Rabbi awzi'nee an ashkura ni'matakal-latee an'amta 'alayya wa 'ala walidayya wa an a'mala salihan tardahu.",
      keyDuaEnglish:
          "“My Lord, enable me to be grateful for Your favor which You have bestowed upon me and upon my parents and to do righteousness of which You approve.”",
      keyDuaReference: "Surah An-Naml (27:19)",
      moralLessons: [
        "Tremendous power and wealth should lead to greater humility and gratitude, not pride.",
        "Kindness and attentiveness to the smallest of Allah's creatures (the ant).",
      ],
    ),

    // 19. ILYAS (AS)
    ProphetItem(
      order: 19,
      id: "ilyas",
      nameEnglish: "Ilyas (Elijah)",
      nameArabic: "إِلْيَاس عَلَيْهِ ٱلسَّلَامُ",
      title: "The Champion Against Baal",
      era: "Kingdom of Israel (~850 BCE)",
      quranMentions: 2,
      keySurahs: "Al-Anbiya, As-Saffat",
      historicalLocation: "Baalbek (Lebanon) & Galilee",
      miracles: [
        "Withholding rain from the idolaters and bringing down rain upon prayer",
        "Overcoming the worship of the idol Baal and restoring pure Tawheed",
      ],
      summary:
          "Sent to the people of Baalbek who worshipped the idol Baal. He courageously challenged their false gods: 'Do you call upon Baal and leave the Best of creators—Allah, your Lord and the Lord of your first forefathers?'",
      milestones: [
        ProphetMilestone(
          title: "Confronting the Cult of Baal",
          description:
              "Ilyas fearlessly denounced the false worship of Baal, surviving persecution and leading believers in upholding the truth.",
          quranReference: "Surah As-Saffat 37:123-126",
        ),
      ],
      keyDuaArabic:
          "سَلَامٌ عَلَىٰ إِلْ يَاسِينَ ۚ إِنَّا كَذَٰلِكَ نَجْزِي الْمُحْسِنِينَ",
      keyDuaTransliteration:
          "Salamun 'ala Ilyaseen; inna kazalika najzil-muhsineen.",
      keyDuaEnglish:
          "“Peace be upon Elias. Indeed, We thus reward the doers of good.”",
      keyDuaReference: "Surah As-Saffat (37:130-131)",
      moralLessons: [
        "Uncompromising stance against superstitious and fashionable false worship.",
        "Allah honors and remembers righteous reformers through all generations.",
      ],
    ),

    // 20. AL-YASA (AS)
    ProphetItem(
      order: 20,
      id: "al-yasa",
      nameEnglish: "Al-Yasa (Elisha)",
      nameArabic: "ٱلْيَسَع عَلَيْهِ ٱلسَّلَامُ",
      title: "The Steadfast Successor in Prophecy",
      era: "Kingdom of Israel (~800 BCE)",
      quranMentions: 2,
      keySurahs: "Al-An'am, Sad",
      historicalLocation: "Levant / Syria",
      miracles: [
        "Healing the sick and purifying waters by Allah's leave",
        "Preserving prophetic wisdom and guiding Bani Israel after Ilyas",
      ],
      summary:
          "The loyal disciple and successor of Prophet Ilyas (AS). Praised in the Quran among the noble prophets: 'And remember Ismail, Elisha, and Dhul-Kifl, and all are among the outstanding.'",
      milestones: [
        ProphetMilestone(
          title: "Continuing the Prophetic Mission",
          description:
              "Al-Yasa picked up the mantle of Da'wah following Ilyas, demonstrating steadfastness, justice, and devotion to Torah principles.",
          quranReference: "Surah Sad 38:48",
        ),
      ],
      keyDuaArabic:
          "رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا",
      keyDuaTransliteration:
          "Rabbana atina mil-ladunka rahmatan wa hayyi' lana min amrina rashada.",
      keyDuaEnglish:
          "“Our Lord, grant us from Yourself mercy and prepare for us from our affair right guidance.”",
      keyDuaReference: "Surah Al-Kahf (18:10)",
      moralLessons: [
        "Carrying forward the mission of righteous mentors with diligence.",
        "Faithful continuity is as important as initiating the message.",
      ],
    ),

    // 21. YUNUS (AS)
    ProphetItem(
      order: 21,
      id: "yunus",
      nameEnglish: "Yunus (Jonah / Dhun-Nun)",
      nameArabic: "يُونُس عَلَيْهِ ٱلسَّلَامُ",
      title: "Dhun-Nun (The Companion of the Whale)",
      era: "Neo-Assyrian Era (~750 BCE)",
      quranMentions: 4,
      keySurahs: "Surah Yunus, Al-Anbiya, As-Saffat, Al-Qalam",
      historicalLocation: "Nineveh (Mosul, Iraq) & Mediterranean Sea",
      miracles: [
        "Surviving alive inside the stomach of a giant whale in total darkness",
        "The whale casting him onto shore upon his heartfelt repentance",
        "A gourd plant (*Yaqteen*) grown over him to provide shade and healing",
        "His entire city of 100,000+ people repenting and being saved from punishment",
      ],
      summary:
          "Sent to Nineveh. Frustrated by their stubbornness, he departed without explicit divine permission, boarded a ship, was cast into the sea, and swallowed by a whale. From the triple darkness, he made the supreme dua of Tawbah.",
      milestones: [
        ProphetMilestone(
          title: "The Storm and the Lot",
          description:
              "At sea, a storm threatened to capsize the ship. Lots were cast to reduce weight, and the lot fell on Yunus three times. He threw himself into the sea.",
          quranReference: "Surah As-Saffat 37:139-141",
        ),
        ProphetMilestone(
          title: "In the Belly of the Whale",
          description:
              "Swallowed by a whale, Yunus recognized his haste. In the darkness of the night, the ocean depths, and the fish's belly, he cried out: 'La ilaha illa Anta subhanaka inni kuntu minaz-zalimin!'",
          quranReference: "Surah Al-Anbiya 21:87-88",
        ),
        ProphetMilestone(
          title: "The City That Believed",
          description:
              "Returned to health, he returned to Nineveh to find over a hundred thousand people had turned to Allah in sincere repentance—the only entire city saved from decreed punishment.",
          quranReference: "Surah Yunus 10:98",
        ),
      ],
      keyDuaArabic:
          "لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ",
      keyDuaTransliteration:
          "La ilaha illa Anta subhanaka innee kuntu minaz-zalimeen.",
      keyDuaEnglish:
          "“There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers.”",
      keyDuaReference: "Surah Al-Anbiya (21:87) - The Master Dua of Relief",
      moralLessons: [
        "Never abandon a duty before receiving permission; persevere with patience.",
        "The Dua of Yunus guarantees relief for any believer facing insurmountable distress.",
        "Genuine communal repentance can avert divine chastisement.",
      ],
    ),

    // 22. ZAKARIYA (AS)
    ProphetItem(
      order: 22,
      id: "zakariya",
      nameEnglish: "Zakariya (Zechariah)",
      nameArabic: "زَكَرِيَّا عَلَيْهِ ٱلسَّلَامُ",
      title: "Guardian of Maryam & Pure Supplicant",
      era: "First Century BCE",
      quranMentions: 7,
      keySurahs: "Ali 'Imran, Maryam, Al-Anbiya",
      historicalLocation: "Jerusalem (Bayt al-Maqdis)",
      miracles: [
        "Granted a righteous son (Yahya) in extreme old age with a barren wife",
        "Given the divine sign of silence for three days, speaking only in gestures",
        "Witnessing out-of-season fruits provided miraculously to Maryam in her sanctuary",
      ],
      summary:
          "The pious priest and guardian of Maryam (mother of Isa). In his fragile old age, inspired by Maryam's miraculous sustenance, he whispered a heartfelt secret prayer for a righteous heir, and Allah granted him Yahya.",
      milestones: [
        ProphetMilestone(
          title: "The Secret Supplication",
          description:
              "Zakariya prayed privately: 'My Lord, my bones are weakened and my head flared with gray, but never have I been unblessed in my prayer to You.'",
          quranReference: "Surah Maryam 19:3-4",
        ),
        ProphetMilestone(
          title: "Glad Tidings of Yahya",
          description:
              "While standing in prayer in the sanctuary, angels called out to him with glad tidings of Yahya, whose very name was novel and given directly by Allah.",
          quranReference: "Surah Ali 'Imran 3:38-41",
        ),
      ],
      keyDuaArabic:
          "رَبِّ لَا تَذَرْنِي فَرْدًا وَأَنتَ خَيْرُ الْوَارِثِينَ",
      keyDuaTransliteration:
          "Rabbi la tadharnī fardan wa Anta khayrul-waritheen.",
      keyDuaEnglish:
          "“My Lord, do not leave me alone [with no heir], while You are the best of inheritors.”",
      keyDuaReference: "Surah Al-Anbiya (21:89)",
      moralLessons: [
        "Praying with quiet intimacy (*Nida'an Khafiyya*) reaches the throne of Allah.",
        "Age, biological limitations, and worldly odds are nothing before Allah's *Kun Fa-Yakoon* (Be, and it is).",
      ],
    ),

    // 23. YAHYA (AS)
    ProphetItem(
      order: 23,
      id: "yahya",
      nameEnglish: "Yahya (John the Baptist)",
      nameArabic: "يَحْيَىٰ عَلَيْهِ ٱلسَّلَامُ",
      title: "Al-Hasur (The Pure, Chaste & Compassionate)",
      era: "First Century CE",
      quranMentions: 5,
      keySurahs: "Ali 'Imran, Maryam, Al-Anbiya",
      historicalLocation: "Judea / Jordan River",
      miracles: [
        "Granted wisdom, deep scriptural understanding, and sound judgment as a youth",
        "Exceptional empathy and tender compassion (*Hananan*) toward all creation",
      ],
      summary:
          "The miraculous son of Zakariya (AS). Known for his ascetic piety, profound compassion, chastity, and devotion. He confirmed the word of Allah and prepared the people for Prophet Isa (AS).",
      milestones: [
        ProphetMilestone(
          title: "Hold Firm to the Scripture",
          description:
              "Allah commanded: 'O Yahya, take the Scripture with determination,' and granted him judgment and wisdom while still a child.",
          quranReference: "Surah Maryam 19:12-14",
        ),
      ],
      keyDuaArabic:
          "وَسَلَامٌ عَلَيْهِ يَوْمَ وُلِدَ وَيَوْمَ يَمُوتُ وَيَوْمَ يُبْعَثُ حَيًّا",
      keyDuaTransliteration:
          "Wa salamun 'alayhi yawma wulida wa yawma yamootu wa yawma yub'athu hayya.",
      keyDuaEnglish:
          "“And peace be upon him the day he was born and the day he dies and the day he is raised alive.”",
      keyDuaReference: "Surah Maryam (19:15)",
      moralLessons: [
        "Tenderness of heart and dutifulness toward parents are the crowning virtues of youth.",
        "Living simply without worldly arrogance (*Wa lam yakun jabbāran 'asiyya*).",
      ],
    ),

    // 24. ISA (AS)
    ProphetItem(
      order: 24,
      id: "isa",
      nameEnglish: "Isa (Jesus)",
      nameArabic: "عِيسَى ٱبْنُ مَرْيَمَ عَلَيْهِ ٱلسَّلَامُ",
      title: "Al-Masih (The Messiah) & Kalimatullah (Word from Allah)",
      era: "First Century CE",
      quranMentions: 25,
      keySurahs: "Ali 'Imran, Maryam, Al-Ma'idah, An-Nisa",
      historicalLocation: "Nazareth, Bethlehem, Jerusalem (Palestine)",
      miracles: [
        "Miraculous birth without a human father to the virgin Maryam",
        "Speaking clearly from the cradle to defend his mother's purity",
        "Fashioning a bird from clay and breathing life into it by Allah's leave",
        "Healing the blind and the leper by Allah's leave",
        "Raising the dead back to life by Allah's leave",
        "Informing people of what they eat and store in their homes",
        "Descending of the heavenly feast (*Al-Ma'idah*) from heaven",
        "Raised alive to the heavens without being crucified or killed",
      ],
      summary:
          "One of the five greatest messengers of resolve (Ulu al-Azm). Created by Allah's word 'Kun' (Be) like Adam, he preached pure monotheism, confirmed the Torah, brought the Gospel (*Al-Injeel*), and foretold Prophet Muhammad ﷺ.",
      milestones: [
        ProphetMilestone(
          title: "The Miraculous Virgin Birth",
          description:
              "Jibril appeared to Maryam to announce the gift of a pure son. She conceived by Allah's spirit and gave birth beneath a date palm.",
          quranReference: "Surah Maryam 19:16-26",
        ),
        ProphetMilestone(
          title: "Speaking in the Cradle",
          description:
              "When Maryam faced false accusations, infant Isa spoke: 'Indeed, I am the servant of Allah. He has given me the Scripture and made me a prophet.'",
          quranReference: "Surah Maryam 19:30-33",
        ),
        ProphetMilestone(
          title: "Ascension and Prophecy of Ahmad",
          description:
              "When enemies plotted to crucify him, Allah protected him and raised him alive unto Himself, giving the glad tidings of a messenger to come: Ahmad (Muhammad ﷺ).",
          quranReference: "Surah An-Nisa 4:157-158, As-Saff 61:6",
        ),
      ],
      keyDuaArabic:
          "رَبَّنَا أَنزِلْ عَلَيْنَا مَائِدَةً مِّنَ السَّمَاءِ تَكُونُ لَنَا عِيدًا لِّأَوَّلِنَا وَآخِرِنَا وَآيَةً مِّنكَ ۖ وَارْزُقْنَا وَأَنتَ خَيْرُ الرَّازِقِينَ",
      keyDuaTransliteration:
          "Rabbana anzil 'alayna ma'idatam-minas-samaa'i takoonu lana 'eedan li-awwalina wa akhirina wa ayatan minka warzuqna wa Anta khayrur-raziqeen.",
      keyDuaEnglish:
          "“O Allah, our Lord, send down to us a table spread [with food] from the heaven to be for us a festival for the first of us and the last of us and a sign from You. And provide for us, and You are the best of providers.”",
      keyDuaReference: "Surah Al-Ma'idah (5:114)",
      moralLessons: [
        "Isa is a noble human prophet and beloved servant of Allah, not a deity or son of God.",
        "Mercy, compassion, and spiritual revitalization must accompany adherence to divine law.",
        "Trust that Allah protects His righteous servants from the plots of their enemies.",
      ],
    ),

    // 25. MUHAMMAD (SAW)
    ProphetItem(
      order: 25,
      id: "muhammad",
      nameEnglish: "Muhammad",
      nameArabic: "مُحَمَّدٌ رَسُولُ اللَّهِ ﷺ",
      title: "Khatam an-Nabiyyin (Seal of the Prophets) & Mercy to the Worlds",
      era: "570 CE – 632 CE",
      quranMentions: 4, // (by name "Muhammad", plus "Ahmad" once, and addressed directly as Nabiy/Rasul dozens of times)
      keySurahs: "Al-Fath, Muhammad, Al-Ahzab, Al-Anbiya, Al-Baqarah",
      historicalLocation: "Makkah & Madinah (Arabian Peninsula)",
      miracles: [
        "The Holy Quran: The living, eternal, inimitable miracle for all times",
        "Al-Isra' wal-Mi'raj: Night Journey to Jerusalem and ascension through seven heavens",
        "Splitting of the Moon (*Inshiqaq al-Qamar*)",
        "Water flowing from between his blessed fingers quenching thousands of companions",
        "The weeping of the palm tree trunk when replaced by a pulpit",
        "Foretelling dozens of precise future historical and scientific events",
        "Transforming broken tribes into the most just and enlightened global civilization",
      ],
      summary:
          "The Final Messenger of Allah to all humanity and jinn, and the leader of all prophets (*Sayyid Walad Adam*). Characterized by Allah as: 'And We have not sent you except as a mercy to the worlds' (21:107).",
      milestones: [
        ProphetMilestone(
          title: "The First Revelation in Cave Hira",
          description:
              "At age 40, in Cave Hira, Angel Jibril embraced him with the first verses of the Quran: 'Read in the name of your Lord who created...'",
          quranReference: "Surah Al-'Alaq 96:1-5",
        ),
        ProphetMilestone(
          title: "Al-Isra' wal-Mi'raj (Night Journey)",
          description:
              "Carried in one night from Makkah to Jerusalem, where he led all prophets in prayer, then ascended past Sidrat al-Muntaha where the five daily prayers were ordained.",
          quranReference: "Surah Al-Isra 17:1, An-Najm 53:1-18",
        ),
        ProphetMilestone(
          title: "The Hijrah & Founding the First Islamic State",
          description:
              "Migrated to Madinah, establishing brotherhood (Mu'akhah), the historic Charter of Madinah, and the first community founded on equality, justice, and monotheism.",
          quranReference: "Surah At-Tawbah 9:40",
        ),
        ProphetMilestone(
          title: "The Peaceful Conquest of Makkah & Farewell Pilgrimage",
          description:
              "Entered Makkah with 10,000 companions with lowered head in humility, declaring general amnesty: 'Go, for you are free!' Delivered the historic Farewell Sermon outlining universal human rights.",
          quranReference: "Surah An-Nasr 110:1-3",
        ),
      ],
      keyDuaArabic:
          "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
      keyDuaTransliteration:
          "Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina 'adhaban-nar.",
      keyDuaEnglish:
          "“Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire.”",
      keyDuaReference: "Surah Al-Baqarah (2:201) - The Most Frequent Dua of the Prophet ﷺ",
      moralLessons: [
        "Mercy, compassion, and justice must guide every human action (*Rahmah*).",
        "Forgiveness in moments of triumph is the hallmark of prophetic character.",
        "The Quran and Sunnah provide timeless guidance for all aspects of life until the Day of Judgment.",
      ],
    ),
  ];
}
