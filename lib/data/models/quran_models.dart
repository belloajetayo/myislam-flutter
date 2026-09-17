class Surah {
  final int number;
  final String name; // Arabic
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int? ?? 1,
      name: json['name'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      englishNameTranslation: json['englishNameTranslation'] as String? ?? '',
      numberOfAyahs: json['numberOfAyahs'] as int? ?? 0,
      revelationType: json['revelationType'] as String? ?? 'Meccan',
    );
  }

  Map<String, dynamic> toJson() => {
    'number': number,
    'name': name,
    'englishName': englishName,
    'englishNameTranslation': englishNameTranslation,
    'numberOfAyahs': numberOfAyahs,
    'revelationType': revelationType,
  };
}

class Ayah {
  final int number;
  final String text; // Arabic
  final int numberInSurah;
  final int juz;
  final int page;
  final String translation;
  final String transliteration;
  final String? audioUrl;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.page,
    this.translation = '',
    this.transliteration = '',
    this.audioUrl,
  });

  factory Ayah.fromJson(Map<String, dynamic> json, {String translation = '', String transliteration = ''}) {
    return Ayah(
      number: json['number'] as int? ?? 1,
      text: json['text'] as String? ?? '',
      numberInSurah: json['numberInSurah'] as int? ?? 1,
      juz: json['juz'] as int? ?? 1,
      page: json['page'] as int? ?? 1,
      translation: translation,
      transliteration: transliteration,
      audioUrl: json['audio'] as String?,
    );
  }
}
