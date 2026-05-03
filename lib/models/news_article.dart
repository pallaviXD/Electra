class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String source;
  final String? imageUrl;
  final DateTime publishedAt;
  final String category;
  final double? biasScore; // -1 (left) to 1 (right), 0 = neutral

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    this.imageUrl,
    required this.publishedAt,
    required this.category,
    this.biasScore,
  });
}
