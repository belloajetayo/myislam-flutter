import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends ChangeNotifier {
  static const String _darkModeKey = "dark_mode";
  static const String _prayersTodayKey = "prayers_completed_today";
  static const String _streakKey = "user_streak";
  static const String _lastPrayerDateKey = "last_prayer_date";
  static const String _quranPagesKey = "quran_pages_read";
  static const String _duasReadCountKey = "duas_read_count";
  static const String _favoriteDuasKey = "favorite_duas_list";
  static const String _arabicFontSizeKey = "dua_arabic_font_size";
  static const String _showTransliterationKey = "dua_show_transliteration";
  static const String _showTranslationKey = "dua_show_translation";

  bool _darkMode = false;
  List<String> _prayersCompleted = [];
  int _streak = 7;
  int _quranPagesRead = 4;
  int _duasRead = 12;
  List<String> _favoriteDuaIds = [];
  double _arabicFontSize = 24.0;
  bool _showTransliteration = true;
  bool _showTranslation = true;

  bool get darkMode => _darkMode;
  List<String> get prayersCompleted => _prayersCompleted;
  int get streak => _streak;
  int get quranPagesRead => _quranPagesRead;
  int get duasRead => _duasRead;
  List<String> get favoriteDuaIds => _favoriteDuaIds;
  double get arabicFontSize => _arabicFontSize;
  bool get showTransliteration => _showTransliteration;
  bool get showTranslation => _showTranslation;

  bool isFavoriteDua(String id) => _favoriteDuaIds.contains(id);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool(_darkModeKey) ?? false;
    _streak = prefs.getInt(_streakKey) ?? 7;
    _quranPagesRead = prefs.getInt(_quranPagesKey) ?? 4;
    _duasRead = prefs.getInt(_duasReadCountKey) ?? 12;
    _favoriteDuaIds = prefs.getStringList(_favoriteDuasKey) ?? [];
    _arabicFontSize = prefs.getDouble(_arabicFontSizeKey) ?? 24.0;
    _showTransliteration = prefs.getBool(_showTransliterationKey) ?? true;
    _showTranslation = prefs.getBool(_showTranslationKey) ?? true;

    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final lastDate = prefs.getString(_lastPrayerDateKey);
    if (lastDate == todayStr) {
      _prayersCompleted = prefs.getStringList(_prayersTodayKey) ?? [];
    } else {
      _prayersCompleted = [];
      await prefs.setString(_lastPrayerDateKey, todayStr);
      await prefs.setStringList(_prayersTodayKey, []);
    }
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _darkMode);
  }

  Future<void> togglePrayer(String prayerName) async {
    if (_prayersCompleted.contains(prayerName)) {
      _prayersCompleted.remove(prayerName);
    } else {
      _prayersCompleted.add(prayerName);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prayersTodayKey, _prayersCompleted);
  }

  Future<void> incrementDuas() async {
    _duasRead++;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_duasReadCountKey, _duasRead);
  }

  Future<void> toggleFavoriteDua(String id) async {
    if (_favoriteDuaIds.contains(id)) {
      _favoriteDuaIds.remove(id);
    } else {
      _favoriteDuaIds.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteDuasKey, _favoriteDuaIds);
  }

  Future<void> setArabicFontSize(double size) async {
    _arabicFontSize = size.clamp(16.0, 42.0);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_arabicFontSizeKey, _arabicFontSize);
  }

  Future<void> toggleTransliteration() async {
    _showTransliteration = !_showTransliteration;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showTransliterationKey, _showTransliteration);
  }

  Future<void> toggleTranslation() async {
    _showTranslation = !_showTranslation;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showTranslationKey, _showTranslation);
  }

  Future<void> incrementQuranPages() async {
    _quranPagesRead++;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_quranPagesKey, _quranPagesRead);
  }
}
