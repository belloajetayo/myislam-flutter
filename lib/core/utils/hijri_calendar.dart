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
}
