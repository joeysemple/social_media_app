import 'package:flutter/material.dart';
import '../models/thread_model.dart';
import '../themes/app_theme.dart';

class ThreadsScreen extends StatelessWidget {
  const ThreadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      // Add more sample threads
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
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
            onPressed: () {
              // TODO: Implement new thread creation
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: threads.length,
        itemBuilder: (context, index) {
          final thread = threads[index];
          return _ThreadCard(thread: thread);
        },
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Row
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
              ],
            ),
            const SizedBox(height: 12),
            // Thread Content
            Text(
              thread.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            // Tags
            if (thread.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                children: thread.tags.map((tag) {
                  return Text(
                    '#$tag',
                    style: TextStyle(
                      color: AppTheme.vsBlue,
                      fontSize: 14,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            // Interaction Buttons
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