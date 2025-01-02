class LiveModel {
  final String id;
  final String streamerId;
  final String streamerUsername;
  final String streamerAvatar;
  final String streamTitle;
  final String streamThumbnail;
  final int viewers;
  final String streamCategory;
  final bool isLive;
  final String streamUrl; // Could be a video stream URL or live stream platform link

  LiveModel({
    required this.id,
    required this.streamerId,
    required this.streamerUsername,
    required this.streamerAvatar,
    required this.streamTitle,
    required this.streamThumbnail,
    required this.viewers,
    required this.streamCategory,
    this.isLive = true,
    required this.streamUrl,
  });

  // Optional method to create mock data
  factory LiveModel.mock({
    String? id,
    String? streamerId,
    String? streamerUsername,
    String? streamerAvatar,
    String? streamTitle,
    String? streamThumbnail,
    int? viewers,
    String? streamCategory,
    bool? isLive,
    String? streamUrl,
  }) {
    return LiveModel(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      streamerId: streamerId ?? 'streamer_${DateTime.now().millisecondsSinceEpoch}',
      streamerUsername: streamerUsername ?? '@live_streamer',
      streamerAvatar: streamerAvatar ?? 'https://i.pravatar.cc/150?img=${DateTime.now().millisecondsSinceEpoch % 10}',
      streamTitle: streamTitle ?? 'Live Streaming Session',
      streamThumbnail: streamThumbnail ?? 'https://via.placeholder.com/350x350',
      viewers: viewers ?? (DateTime.now().millisecondsSinceEpoch % 1000),
      streamCategory: streamCategory ?? 'Gaming',
      isLive: isLive ?? true,
      streamUrl: streamUrl ?? 'https://example.com/live_stream',
    );
  }
}