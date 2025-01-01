import 'package:flutter/material.dart';
import '../widgets/video_post_card.dart';
import '../models/video_model.dart';
import '../themes/app_theme.dart';
import '../widgets/discover_grid.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});
  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedTab = 2; // Start with "For You" tab
  final Map<int, GlobalKey<VideoPostCardState>> _videoKeys = {};

  final List<Map<String, dynamic>> _tabs = [
    {
      'label': 'Live',
      'dotColor': Colors.red,
    },
    {
      'label': 'Discover',
      'dotColor': AppTheme.vsLightBlue,
    },
    {
      'label': 'For You',
      'dotColor': AppTheme.vsBlue,
    },
    {
      'label': 'Following',
      'dotColor': Colors.green,
    },
  ];

  final List<VideoModel> _forYouVideos = [
    VideoModel(
      id: '1',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      userAvatar: 'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
      username: '@johndoe',
      description: 'Check out this cool video! #trending #viral',
      likes: 1200,
      comments: 234,
      shares: 45,
    ),
    VideoModel(
      id: '2',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      username: '@techie',
      description: 'Another awesome video 🎥 #coding #tech',
      likes: 845,
      comments: 156,
      shares: 32,
    ),
  ];

  final List<VideoModel> _liveVideos = [];
  final List<VideoModel> _discoverVideos = [];
  final List<VideoModel> _followingVideos = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideoKeys();
  }

  void _initializeVideoKeys() {
    _videoKeys.clear();
    final currentVideos = _getCurrentFeedVideos();
    for (int i = 0; i < currentVideos.length; i++) {
      _videoKeys[i] = GlobalKey<VideoPostCardState>();
    }
    print('Initialized video keys for tab $_selectedTab');
  }

  List<VideoModel> _getCurrentFeedVideos() {
    switch (_selectedTab) {
      case 0:
        return _liveVideos;
      case 1:
        return _discoverVideos;
      case 2:
        return _forYouVideos;
      case 3:
        return _followingVideos;
      default:
        return _forYouVideos;
    }
  }

  @override
  void dispose() {
    _pauseAllVideos();
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _pauseAllVideos();
    }
  }

  void _pauseAllVideos() {
    _videoKeys.forEach((_, key) {
      final videoCard = key.currentState;
      videoCard?.pauseVideo();
    });
  }

  void _handlePageChange(int index) {
    final previousVideo = _videoKeys[_currentPage]?.currentState;
    previousVideo?.pauseVideo();
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_selectedTab == 1)
            DiscoverGrid(
              videos: _discoverVideos.isEmpty ? _forYouVideos : _discoverVideos,
              onVideoTap: (video) {
                print('Video tapped: ${video.id}');
              },
              onBackPress: () {
                setState(() {
                  _selectedTab = 2; // Go back to "For You" feed
                  _currentPage = 0;
                });
                _initializeVideoKeys();
                _pageController.jumpToPage(0);
              },
            )
          else if (_getCurrentFeedVideos().isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No ${_tabs[_selectedTab]['label']} content yet',
                    style: TextStyle(
                      color: _tabs[_selectedTab]['dotColor'],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              onPageChanged: _handlePageChange,
              itemCount: _getCurrentFeedVideos().length,
              itemBuilder: (context, index) {
                return VideoPostCard(
                  key: _videoKeys[index],
                  video: _getCurrentFeedVideos()[index],
                  isVisible: _currentPage == index,
                );
              },
            ),
          _buildHorizontalNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildHorizontalNavigationBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: _tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                final isSelected = _selectedTab == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = index;
                      _currentPage = 0;
                    });
                    _initializeVideoKeys();
                    _pageController.jumpToPage(0);
                    print('Switched to tab: $_selectedTab');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      tab['label'],
                      style: TextStyle(
                        color: isSelected
                            ? tab['dotColor']
                            : Colors.white.withOpacity(0.8),
                        fontSize: isSelected ? 18 : 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: VideoSearchDelegate(_forYouVideos),
                );
              },
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoSearchDelegate extends SearchDelegate {
  final List<VideoModel> videos;

  VideoSearchDelegate(this.videos);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = videos
        .where((video) => video.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final video = results[index];
        return ListTile(
          leading: Image.network(video.userAvatar),
          title: Text(video.username),
          subtitle: Text(video.description),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = videos
        .where((video) => video.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final video = suggestions[index];
        return ListTile(
          leading: Image.network(video.userAvatar),
          title: Text(video.username),
        );
      },
    );
  }
}
