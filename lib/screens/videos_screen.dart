import 'package:flutter/material.dart';
import '../widgets/video_post_card.dart';
import '../models/video_model.dart';
import '../themes/app_theme.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});
  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedTab = 2; // Start with "For You" tab
  final Map<int, GlobalKey<VideoPostCardState>> _videoKeys = {};

  final List<Map<String, dynamic>> _tabs = [
    {
      'icon': Icons.live_tv_rounded,
      'label': 'Live',
      'dotColor': Colors.red,
    },
    {
      'icon': Icons.explore_rounded,
      'label': 'Discover',
      'dotColor': AppTheme.vsLightBlue,
    },
    {
      'icon': Icons.local_fire_department_rounded,
      'label': 'For You',
      'dotColor': AppTheme.vsBlue,
    },
    {
      'icon': Icons.people_rounded,
      'label': 'Following',
      'dotColor': Colors.green,
    },
  ];

  // Add sample videos for "For You" feed
  final List<VideoModel> _forYouVideos = [
    VideoModel(
      id: '1',
      videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      userAvatar: 'https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg',
      username: '@johndoe',
      description: 'Check out this cool video! #trending #viral',
      likes: 1200,
      comments: 234,
      shares: 45,
    ),
    VideoModel(
      id: '2',
      videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      username: '@techie',
      description: 'Another awesome video 🎥 #coding #tech',
      likes: 845,
      comments: 156,
      shares: 32,
    ),
    VideoModel(
      id: '3',
      videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      username: '@creator',
      description: 'Making content is fun! 🎮 #create #inspire',
      likes: 2100,
      comments: 342,
      shares: 89,
    ),
    VideoModel(
      id: '4',
      videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      userAvatar: 'https://i.pravatar.cc/150?img=4',
      username: '@traveler',
      description: 'Adventures never end! 🌎 #travel #explore',
      likes: 3400,
      comments: 445,
      shares: 120,
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
    final currentVideos = _getCurrentFeedVideos();

    return Stack(
      children: [
        if (currentVideos.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _tabs[_selectedTab]['icon'],
                  size: 48,
                  color: _tabs[_selectedTab]['dotColor'],
                ),
                const SizedBox(height: 16),
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
            itemCount: currentVideos.length,
            itemBuilder: (context, index) {
              return VideoPostCard(
                key: _videoKeys[index],
                video: currentVideos[index],
                isVisible: _currentPage == index,
              );
            },
          ),
        _buildTabBar(),
      ],
    );
  }

  Widget _buildTabBar() {
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: Container(
              width: 60,
              height: MediaQuery.of(context).size.height - 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: _tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  final isSelected = _selectedTab == index;
                  
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTab = index;
                        _currentPage = 0;
                      });
                      _initializeVideoKeys();
                      _pageController.jumpToPage(0);
                      print('Switched to tab: $_selectedTab');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? tab['dotColor'].withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? tab['dotColor'].withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Icon(
                                tab['icon'],
                                color: isSelected 
                                    ? tab['dotColor']
                                    : Colors.white.withOpacity(0.8),
                                size: 24,
                              ),
                            ],
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 4),
                            Text(
                              tab['label'],
                              style: TextStyle(
                                color: tab['dotColor'],
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 16),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.8),
                    size: 24,
                  ),
                  onPressed: () {
                    print('Search pressed');
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
