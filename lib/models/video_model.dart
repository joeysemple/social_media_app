class VideoModel {
  final String id;
  final String videoUrl;
  final String userAvatar;
  final String username;
  final String description;
  final int likes;
  final int comments;
  final int shares;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.userAvatar,
    required this.username,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}