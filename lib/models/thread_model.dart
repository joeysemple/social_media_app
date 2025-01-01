class ThreadModel {
  final String id;
  final String username;
  final String userAvatar;
  final String content;
  final String timestamp;
  int likes;
  int comments;
  int reposts;
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

class CommentModel {
  final String id;
  final String username;
  final String content;
  final String timestamp;
  int likes;

  CommentModel({
    required this.id,
    required this.username,
    required this.content,
    required this.timestamp,
    this.likes = 0,
  });
}