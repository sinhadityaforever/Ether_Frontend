class FeedCard {
  final int id;
  final String heading;
  final bool isVideo;
  final String imageUrl;
  final String content;
  final String desco;
  final int occupationId;
  final int startAt;
  final int endAt;

  FeedCard({
    required this.id,
    required this.heading,
    required this.isVideo,
    required this.imageUrl,
    required this.content,
    required this.desco,
    required this.occupationId,
    required this.startAt,
    required this.endAt,
  });
}
