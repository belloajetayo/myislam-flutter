class DuaCategory {
  final String id;
  final String name;
  final String arabicName;
  final String icon;
  final String desc;
  final List<int> gradientColors;
  final int duaCount;

  const DuaCategory({
    required this.id,
    required this.name,
    this.arabicName = '',
    required this.icon,
    required this.desc,
    required this.gradientColors,
    this.duaCount = 0,
  });
}

class DuaItem {
  final String id;
  final String categoryId;
  final String title;
  final String? subTitle;
  final String arabic;
  final String transliteration;
  final String translation;
  final String reference;
  final int targetCount;
  final String? benefit;
  final String? audioUrl;
  final List<String> tags;

  const DuaItem({
    required this.id,
    required this.categoryId,
    required this.title,
    this.subTitle,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
    this.targetCount = 1,
    this.benefit,
    this.audioUrl,
    this.tags = const [],
  });

  // Backward compatibility getters
  String get source => reference;
  int get times => targetCount;
}
