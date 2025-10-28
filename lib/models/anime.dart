class Anime {
  final int malId;
  final String title;
  final String? imageUrl;
  final double? score;
  final int? episodes;
  final String? synopsis;
  final int? year;
  final String? season;

  Anime({
    required this.malId,
    required this.title,
    this.imageUrl,
    this.score,
    this.episodes,
    this.synopsis,
    this.year,
    this.season,
  });

  factory Anime.fromListJson(Map<String, dynamic> j) {
    // JSON untuk list (top/search) dan detail sama kuncinya
    final images = j['images']?['jpg'];
    return Anime(
      malId: j['mal_id'],
      title: j['title'] ?? j['title_english'] ?? j['title_japanese'] ?? 'Untitled',
      imageUrl: images?['image_url'],
      score: (j['score'] as num?)?.toDouble(),
      episodes: j['episodes'] as int?,
      synopsis: j['synopsis'] as String?,
      year: j['year'] as int?,
      season: j['season'] as String?,
    );
  }
}
