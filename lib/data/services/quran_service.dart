import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/quran_models.dart';

class QuranService extends ChangeNotifier {
  List<Surah> _surahs = [];
  bool _isLoading = false;
  String? _error;

  List<Surah> get surahs => _surahs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  QuranService() {
    _loadInitialSurahs();
  }

  void _loadInitialSurahs() {
    // Standard initial surahs
    _surahs = [
      Surah(number: 1, name: "الفَاتِحة", englishName: "Al-Faatiha", englishNameTranslation: "The Opening", numberOfAyahs: 7, revelationType: "Meccan"),
      Surah(number: 2, name: "البَقَرَة", englishName: "Al-Baqara", englishNameTranslation: "The Cow", numberOfAyahs: 286, revelationType: "Medinan"),
      Surah(number: 3, name: "آل عِمرَان", englishName: "Aal-i-Imraan", englishNameTranslation: "The Family of Imraan", numberOfAyahs: 200, revelationType: "Medinan"),
      Surah(number: 4, name: "النِّسَاء", englishName: "An-Nisaa", englishNameTranslation: "The Women", numberOfAyahs: 176, revelationType: "Medinan"),
      Surah(number: 36, name: "يس", englishName: "Yaseen", englishNameTranslation: "Yaseen", numberOfAyahs: 83, revelationType: "Meccan"),
      Surah(number: 55, name: "الرَّحْمَٰن", englishName: "Ar-Rahmaan", englishNameTranslation: "The Beneficent", numberOfAyahs: 78, revelationType: "Medinan"),
      Surah(number: 67, name: "المُلْك", englishName: "Al-Mulk", englishNameTranslation: "The Sovereignty", numberOfAyahs: 30, revelationType: "Meccan"),
      Surah(number: 112, name: "الإِخْلَاص", englishName: "Al-Ikhlaas", englishNameTranslation: "The Sincerity", numberOfAyahs: 4, revelationType: "Meccan"),
      Surah(number: 113, name: "الفَلَق", englishName: "Al-Falaq", englishNameTranslation: "The Daybreak", numberOfAyahs: 5, revelationType: "Meccan"),
      Surah(number: 114, name: "النَّاس", englishName: "An-Naas", englishNameTranslation: "Mankind", numberOfAyahs: 6, revelationType: "Meccan"),
    ];
  }

  Future<void> fetchAllSurahs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("https://api.alquran.cloud/v1/surah")).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          final list = (data['data'] as List).map((item) => Surah.fromJson(item)).toList();
          _surahs = list;
          _error = null;
        }
      }
    } catch (e) {
      _error = "Using offline Surahs list";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Ayah>> fetchSurahAyahs(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse("https://api.alquran.cloud/v1/surah/$surahNumber/editions/quran-uthmani,en.sahih,en.transliteration"),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          final editions = data['data'] as List;
          final arabicList = editions[0]['ayahs'] as List;
          final englishList = editions.length > 1 ? editions[1]['ayahs'] as List : [];
          final translitList = editions.length > 2 ? editions[2]['ayahs'] as List : [];

          List<Ayah> ayahs = [];
          for (int i = 0; i < arabicList.length; i++) {
            final ar = arabicList[i];
            final en = i < englishList.length ? englishList[i]['text'] : "";
            final tr = i < translitList.length ? translitList[i]['text'] : "";
            ayahs.add(Ayah.fromJson(ar, translation: en, transliteration: tr));
          }
          return ayahs;
        }
      }
    } catch (_) {}

    // Fallback sample for Surah Al-Fatiha
    return [
      Ayah(number: 1, text: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", numberInSurah: 1, juz: 1, page: 1, translation: "In the name of Allah, the Entirely Merciful, the Especially Merciful.", transliteration: "Bismillaahir Rahmaanir Raheem"),
      Ayah(number: 2, text: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", numberInSurah: 2, juz: 1, page: 1, translation: "[All] praise is [due] to Allah, Lord of the worlds -", transliteration: "Alhamdu lillaahi Rabbil 'aalameen"),
      Ayah(number: 3, text: "الرَّحْمَٰنِ الرَّحِيمِ", numberInSurah: 3, juz: 1, page: 1, translation: "The Entirely Merciful, the Especially Merciful,", transliteration: "Ar-Rahmaanir-Raheem"),
      Ayah(number: 4, text: "مَالِكِ يَوْمِ الدِّينِ", numberInSurah: 4, juz: 1, page: 1, translation: "Sovereign of the Day of Recompense.", transliteration: "Maaliki Yawmid-Deen"),
      Ayah(number: 5, text: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", numberInSurah: 5, juz: 1, page: 1, translation: "It is You we worship and You we ask for help.", transliteration: "Iyyaaka na'budu wa lyyaaka nasta'een"),
      Ayah(number: 6, text: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ", numberInSurah: 6, juz: 1, page: 1, translation: "Guide us to the straight path -", transliteration: "Ihdinas-Siraatal-Mustaqeem"),
      Ayah(number: 7, text: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", numberInSurah: 7, juz: 1, page: 1, translation: "The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.", transliteration: "Siraatal-lazeena an'amta 'alayhim ghayril-maghdoobi 'alayhim wa lad-daalleen"),
    ];
  }
}
