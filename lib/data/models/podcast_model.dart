class PodcastShow {
  final String id;
  final String title;
  final String speaker;
  final String description;
  final String category; // Tafseer, Seerah, Heart Therapy, Contemporary, Youth & Family
  final String icon;
  final double rating;
  final List<PodcastEpisode> episodes;

  const PodcastShow({
    required this.id,
    required this.title,
    required this.speaker,
    required this.description,
    required this.category,
    required this.icon,
    this.rating = 4.9,
    required this.episodes,
  });
}

class PodcastEpisode {
  final String id;
  final String showId;
  final String showTitle;
  final String speaker;
  final String title;
  final String description;
  final String duration; // e.g. "24:15"
  final Duration estimatedDuration;
  final String audioUrl;
  final String releaseDate;
  final String topic;

  const PodcastEpisode({
    required this.id,
    required this.showId,
    required this.showTitle,
    required this.speaker,
    required this.title,
    required this.description,
    required this.duration,
    required this.estimatedDuration,
    required this.audioUrl,
    required this.releaseDate,
    required this.topic,
  });
}
