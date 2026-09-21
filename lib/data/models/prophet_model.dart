class ProphetItem {
  final int order; // 1 to 25
  final String id;
  final String nameEnglish;
  final String nameArabic;
  final String title;
  final String era;
  final int quranMentions;
  final String keySurahs;
  final String historicalLocation;
  final List<String> miracles;
  final String summary;
  final List<ProphetMilestone> milestones;
  final String keyDuaArabic;
  final String keyDuaTransliteration;
  final String keyDuaEnglish;
  final String keyDuaReference;
  final List<String> moralLessons;

  const ProphetItem({
    required this.order,
    required this.id,
    required this.nameEnglish,
    required this.nameArabic,
    required this.title,
    required this.era,
    required this.quranMentions,
    required this.keySurahs,
    required this.historicalLocation,
    required this.miracles,
    required this.summary,
    required this.milestones,
    required this.keyDuaArabic,
    required this.keyDuaTransliteration,
    required this.keyDuaEnglish,
    required this.keyDuaReference,
    required this.moralLessons,
  });
}

class ProphetMilestone {
  final String title;
  final String description;
  final String? quranReference;

  const ProphetMilestone({
    required this.title,
    required this.description,
    this.quranReference,
  });
}
