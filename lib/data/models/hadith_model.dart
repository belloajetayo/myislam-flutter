class HadithCategory {
  final int id;
  final String category;
  final String categoryArabic;
  final String icon;
  final List<HadithItem> hadiths;

  const HadithCategory({
    required this.id,
    required this.category,
    required this.categoryArabic,
    this.icon = "📖",
    required this.hadiths,
  });
}

class HadithItem {
  final int number;
  final String title;
  final String arabic;
  final String translation;
  final String narrator;
  final String source;
  final String grade;
  final String explanation;
  final String collection;
  final String topic;

  const HadithItem({
    required this.number,
    required this.title,
    required this.arabic,
    required this.translation,
    required this.narrator,
    required this.source,
    this.grade = "Sahih",
    required this.explanation,
    this.collection = "40 Hadith Nawawi",
    this.topic = "General Guidance",
  });
}
