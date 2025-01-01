import 'package:flutter/material.dart';
import '../models/thread_model.dart';
import '../themes/app_theme.dart';
import 'new_thread_screen.dart';
import '../screens/category_management_screen.dart'; // Import the new screen

class ThreadsScreen extends StatefulWidget {
  const ThreadsScreen({super.key});

  @override
  State<ThreadsScreen> createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends State<ThreadsScreen> {
  String _selectedCategory = 'For You';
  List<String> _categories = [
    'For You',
    'Following',
    'Programming',
    'Design',
    'Tech',
    'Career',
    'Mobile',
  ];

  // Sample thread data
  final List<ThreadModel> threads = [
    ThreadModel(
      id: '1',
      username: '@techie',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      content: 'Just deployed my first Flutter app to production! The developer experience has been amazing. What are your favorite Flutter features? #flutter #mobile #dev',
      timestamp: '2h',
      likes: 142,
      comments: 23,
      reposts: 12,
      tags: ['flutter', 'mobile', 'dev'],
    ),
    ThreadModel(
      id: '2',
      username: '@designerPro',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      content: 'Material Design 3 is changing the game. The new color system and dynamic color feature are revolutionary for brand consistency.',
      timestamp: '4h',
      likes: 89,
      comments: 15,
      reposts: 8,
      tags: ['design', 'ui'],
    ),
    ThreadModel(
      id: '3',
      username: '@codingNinja',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      content: 'Just finished an intense debugging session. Pro tip: always use meaningful variable names and write clean, modular code! #programming #bestpractices',
      timestamp: '1d',
      likes: 276,
      comments: 45,
      reposts: 22,
      tags: ['programming', 'coding'],
    ),
    ThreadModel(
      id: '4',
      username: '@mobileDevGuru',
      userAvatar: 'https://i.pravatar.cc/150?img=4',
      content: 'State management in mobile apps can be tricky. Been experimenting with Provider and Riverpod - both have their pros and cons. What\'s your go-to solution? #flutter #mobiledev',
      timestamp: '12h',
      likes: 203,
      comments: 37,
      reposts: 16,
      tags: ['flutter', 'statemanagement'],
    ),
    ThreadModel(
      id: '5',
      username: '@uiuxMaster',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'Accessibility in design is not an afterthought - it\'s a fundamental requirement. Always design with inclusivity in mind. #ux #design #accessibility',
      timestamp: '6h',
      likes: 345,
      comments: 56,
      reposts: 29,
      tags: ['ux', 'design', 'accessibility'],
    ),
    ThreadModel(
      id: '6',
      username: '@techCareer',
      userAvatar: 'https://i.pravatar.cc/150?img=6',
      content: 'Career advice: Never stop learning. The tech world moves fast, and continuous learning is your greatest asset. Courses, side projects, conferences - use them all! #careertips #tech',
      timestamp: '22h',
      likes: 412,
      comments: 78,
      reposts: 35,
      tags: ['career', 'learning'],
    ),
    ThreadModel(
      id: '7',
      username: '@openSourceHero',
      userAvatar: 'https://i.pravatar.cc/150?img=7',
      content: 'Contributing to open source is the best way to level up your coding skills. Started my first meaningful PR this week! #opensource #coding #community',
      timestamp: '5h',
      likes: 189,
      comments: 32,
      reposts: 14,
      tags: ['opensource', 'coding'],
    )
  ];

  void _navigateToCategoryManagement() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryManagementScreen(
          currentCategories: _categories,
        ),
      ),
    );

    // Update categories if a new list is returned
    if (result != null && result is List<String>) {
      setState(() {
        _categories = result;
        // Reset selected category to 'For You' if current selection is no longer valid
        if (!_categories.contains(_selectedCategory)) {
          _selectedCategory = 'For You';
        }
      });
    }
  }

  void _navigateToNewThread() async {
    // Navigate to NewThreadScreen and wait for result
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewThreadScreen(),
      ),
    );

    // If a new thread is created, add it to the threads list
    if (result != null && result is ThreadModel) {
      setState(() {
        threads.insert(0, result); // Add new thread to the top of the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: AppTheme.primaryBlack,
            pinned: true,
            title: Text(
              'Threads',
              style: TextStyle(
                color: AppTheme.vsBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: AppTheme.vsBlue,
                ),
                onPressed: _navigateToCategoryManagement,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        showCheckmark: false,
                        label: Text(category),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.vsLightBlue,
                          fontSize: 13,
                        ),
                        backgroundColor: isSelected 
                            ? AppTheme.vsBlue.withOpacity(0.2)
                            : AppTheme.surfaceBlack,
                        side: BorderSide(
                          color: isSelected 
                              ? AppTheme.vsBlue 
                              : AppTheme.vsGrey.withOpacity(0.3),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
        body: ListView.builder(
          itemCount: threads.length,
          itemBuilder: (context, index) {
            final thread = threads[index];
            return _ThreadCard(thread: thread);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.vsBlue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _navigateToNewThread,
      ),
    );
  }
}

class _ThreadCard extends StatelessWidget {
  final ThreadModel thread;

  const _ThreadCard({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: AppTheme.secondaryBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to thread detail view
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(thread.userAvatar),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thread.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        thread.timestamp,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () {
                      // TODO: Show thread options
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                thread.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              if (thread.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: thread.tags.map((tag) {
                    return InkWell(
                      onTap: () {
                        // TODO: Navigate to tag view
                      },
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          color: AppTheme.vsBlue,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInteractionButton(
                    Icons.favorite_border,
                    thread.likes.toString(),
                  ),
                  _buildInteractionButton(
                    Icons.comment_outlined,
                    thread.comments.toString(),
                  ),
                  _buildInteractionButton(
                    Icons.repeat,
                    thread.reposts.toString(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String count) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {},
        ),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}