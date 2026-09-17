class PrayerTimesModel {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String date;
  final String city;
  final String country;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.city,
    required this.country,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json, {String city = "Lagos", String country = "Nigeria"}) {
    final timings = json['timings'] as Map<String, dynamic>? ?? {};
    return PrayerTimesModel(
      fajr: _cleanTime(timings['Fajr'] ?? "05:15"),
      sunrise: _cleanTime(timings['Sunrise'] ?? "06:30"),
      dhuhr: _cleanTime(timings['Dhuhr'] ?? "12:45"),
      asr: _cleanTime(timings['Asr'] ?? "16:05"),
      maghrib: _cleanTime(timings['Maghrib'] ?? "18:45"),
      isha: _cleanTime(timings['Isha'] ?? "20:00"),
      date: json['date']?['readable'] ?? "",
      city: city,
      country: country,
    );
  }

  static String _cleanTime(String raw) {
    // Remove timezone suffix like (EAT) or (+01)
    return raw.split(" ")[0].trim();
  }

  Map<String, String> toMap() {
    return {
      "Fajr": fajr,
      "Sunrise": sunrise,
      "Dhuhr": dhuhr,
      "Asr": asr,
      "Maghrib": maghrib,
      "Isha": isha,
    };
  }

  /// Default fallback times if network is offline
  factory PrayerTimesModel.defaultTimes() {
    return PrayerTimesModel(
      fajr: "05:15",
      sunrise: "06:30",
      dhuhr: "12:45",
      asr: "16:10",
      maghrib: "18:50",
      isha: "20:05",
      date: "",
      city: "Makkah",
      country: "Saudi Arabia",
    );
  }
}
