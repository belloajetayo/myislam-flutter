class RadioStation {
  final String name;
  final String description;
  final String url;
  final String flag;
  final String? country;

  const RadioStation({
    required this.name,
    required this.description,
    required this.url,
    required this.flag,
    this.country,
  });
}
