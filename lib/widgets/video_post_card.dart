import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../themes/app_theme.dart';
import '../models/video_model.dart';
import '../widgets/comments_sheet.dart';

class VideoPostCard extends StatefulWidget {
  final VideoModel video;
  final bool isVisible;

  const VideoPostCard({
    super.key,
    required this.video,
    this.isVisible = true,
  });

  static VideoPostCardState? of(BuildContext context) => 
      context.findAncestorStateOfType<VideoPostCardState>();

  @override
  State<VideoPostCard> createState() => VideoPostCardState();
}

class VideoPostCardState extends State<VideoPostCard> {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController = VideoPlayerController.network(widget.video.videoUrl);
    await _videoPlayerController.initialize();
    if (mounted) {
      setState(() {});
      if (widget.isVisible) {
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void pauseVideo() {
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _videoPlayerController.play();
      } else {
        _videoPlayerController.pause();
      }
    });
  }

  @override
  void didUpdateWidget(VideoPostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _videoPlayerController.play();
        _isPlaying = true;
      } else {
        _videoPlayerController.pause();
        _isPlaying = false;
      }
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.vsBlue,
                    ),
                  ),
          ),

          // Play/Pause Indicator
          if (!_isPlaying && _videoPlayerController.value.isInitialized)
            const Center(
              child: Icon(
                Icons.play_arrow,
                size: 80,
                color: Colors.white70,
              ),
            ),

          // Interaction Buttons
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                _buildInteractionButton(
                  Icons.favorite,
                  widget.video.likes.toString(),
                  onTap: () {
                    // Implement like functionality
                  },
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                _buildInteractionButton(
                  Icons.comment,
                  widget.video.comments.toString(),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => CommentsSheet(
                        commentCount: widget.video.comments,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildInteractionButton(
                  Icons.share,
                  widget.video.shares.toString(),
                  onTap: () {
                    // Implement share functionality
                  },
                ),
              ],
            ),
          ),

          // User Info
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.video.userAvatar),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.video.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.video.description,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(
    IconData icon,
    String label, {
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.vsGrey.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}