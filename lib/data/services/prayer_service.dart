import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_times_model.dart';
import '../../core/utils/hijri_calendar.dart';

class PrayerService extends ChangeNotifier {
  PrayerTimesModel _times = PrayerTimesModel.defaultTimes();
  bool _isLoading = false;
  String _currentPrayer = "Dhuhr";
  String _nextPrayer = "Asr";
  String _timeUntilNext = "01:45:10";
  HijriDate _hijriDate = HijriDate.fromGregorian(DateTime.now());
  Timer? _countdownTimer;

  PrayerTimesModel get times => _times;
  bool get isLoading => _isLoading;
  String get currentPrayer => _currentPrayer;
  String get nextPrayer => _nextPrayer;
  String get timeUntilNext => _timeUntilNext;
  HijriDate get hijriDate => _hijriDate;

  PrayerService() {
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchPrayerTimes({double lat = 6.5244, double lng = 3.3792, String city = "Lagos", String country = "Nigeria"}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final url = Uri.parse("https://api.aladhan.com/v1/timings/$ts?latitude=$lat&longitude=$lng&method=2");
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200) {
          _times = PrayerTimesModel.fromJson(data['data'], city: city, country: country);
          _calculatePrayers();
        }
      }
    } catch (e) {
      // Fallback already assigned in _times
      _calculatePrayers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculatePrayers();
      notifyListeners();
    });
  }

  void _calculatePrayers() {
    final now = DateTime.now();
    final prayerList = [
      {"name": "Fajr", "time": _parseTime(_times.fajr, now)},
      {"name": "Dhuhr", "time": _parseTime(_times.dhuhr, now)},
      {"name": "Asr", "time": _parseTime(_times.asr, now)},
      {"name": "Maghrib", "time": _parseTime(_times.maghrib, now)},
      {"name": "Isha", "time": _parseTime(_times.isha, now)},
    ];

    String current = "Isha";
    String next = "Fajr";
    DateTime nextTime = _parseTime(_times.fajr, now.add(const Duration(days: 1)));

    for (int i = 0; i < prayerList.length; i++) {
      final pTime = prayerList[i]["time"] as DateTime;
      if (now.isAfter(pTime)) {
        current = prayerList[i]["name"] as String;
        if (i < prayerList.length - 1) {
          next = prayerList[i + 1]["name"] as String;
          nextTime = prayerList[i + 1]["time"] as DateTime;
        } else {
          next = prayerList[0]["name"] as String;
          nextTime = _parseTime(_times.fajr, now.add(const Duration(days: 1)));
        }
      }
    }

    if (now.isBefore(prayerList[0]["time"] as DateTime)) {
      current = "Isha";
      next = "Fajr";
      nextTime = prayerList[0]["time"] as DateTime;
    }

    _currentPrayer = current;
    _nextPrayer = next;

    final diff = nextTime.difference(now);
    if (!diff.isNegative) {
      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
      _timeUntilNext = "$hours:$minutes:$seconds";
    } else {
      _timeUntilNext = "00:00:00";
    }
  }

  DateTime _parseTime(String timeStr, DateTime base) {
    try {
      final parts = timeStr.split(":");
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      return DateTime(base.year, base.month, base.day, h, m);
    } catch (_) {
      return base;
    }
  }
}
