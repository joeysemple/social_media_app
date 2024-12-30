class ThreadModel {
  final String id;
  final String username;
  final String userAvatar;
  final String content;
  final String timestamp;
  final int likes;
  final int comments;
  final int reposts;
  final List<String> tags;

  ThreadModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.reposts,
    this.tags = const [],
  });
}