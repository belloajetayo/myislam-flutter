class HadithCategory {
  final int id;
  final String category;
  final String categoryArabic;
  final List<HadithItem> hadiths;

  const HadithCategory({
    required this.id,
    required this.category,
    required this.categoryArabic,
    required this.hadiths,
  });
}

class HadithItem {
  final String arabic;
  final String translation;
  final String narrator;
  final String source;
  final String explanation;

  const HadithItem({
    required this.arabic,
    required this.translation,
    required this.narrator,
    required this.source,
    required this.explanation,
  });
}
