import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../themes/app_theme.dart';

class DiscoverGrid extends StatelessWidget {
  final List<VideoModel> videos;
  final Function(VideoModel) onVideoTap;
  final VoidCallback onBackPress;

  const DiscoverGrid({
    super.key,
    required this.videos,
    required this.onVideoTap,
    required this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    // Add additional dummy data for scrolling
    final extendedVideos = List<VideoModel>.from(videos)
      ..addAll(List.generate(
        20,
        (index) => VideoModel(
          id: (videos.length + index + 1).toString(),
          videoUrl: 'https://example.com/video${index + 1}.mp4',
          userAvatar: 'https://i.pravatar.cc/150?img=${index + 1}',
          username: '@user${index + 1}',
          description: 'This is a sample video description #${index + 1}',
          likes: 100 + index * 10,
          comments: 20 + index * 5,
          shares: 5 + index,
        ),
      ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Top Bar
              SliverAppBar(
                backgroundColor: Colors.black.withOpacity(0.9),
                pinned: true,
              ),

              // Trending Categories
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trending Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCategoryChip('Gaming', Icons.sports_esports),
                            _buildCategoryChip('Music', Icons.music_note),
                            _buildCategoryChip('Technology', Icons.computer),
                            _buildCategoryChip('Sports', Icons.sports_basketball),
                            _buildCategoryChip('Comedy', Icons.sentiment_very_satisfied),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Video Grid
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildVideoCard(extendedVideos[index]),
                    childCount: extendedVideos.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        print('Category tapped: $label');
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.vsBlue.withOpacity(0.8), AppTheme.vsBlue.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppTheme.vsBlue.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(VideoModel video) {
    return GestureDetector(
      onTap: () => onVideoTap(video),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(video.userAvatar),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(video.userAvatar),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          video.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



