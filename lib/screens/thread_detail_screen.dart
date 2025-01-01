import 'package:flutter/material.dart';
import '../models/thread_model.dart';
import '../themes/app_theme.dart';

class ThreadDetailScreen extends StatefulWidget {
  final ThreadModel thread;

  const ThreadDetailScreen({Key? key, required this.thread}) : super(key: key);

  @override
  _ThreadDetailScreenState createState() => _ThreadDetailScreenState();
}

class _ThreadDetailScreenState extends State<ThreadDetailScreen> {
  late ThreadModel _thread;
  bool _isLiked = false;
  final TextEditingController _commentController = TextEditingController();
  final List<CommentModel> _comments = [
    CommentModel(
      id: '1',
      username: '@techieReply',
      content: 'Great point about Flutter development!',
      timestamp: '1h',
      likes: 5,
    ),
    CommentModel(
      id: '2',
      username: '@designPro',
      content: 'Totally agree with your design insights.',
      timestamp: '30m',
      likes: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _thread = widget.thread;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _thread.likes += _isLiked ? 1 : -1;
    });
  }

  void _addComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      setState(() {
        _comments.insert(0, CommentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          username: '@currentUser', // TODO: Replace with actual username
          content: commentText,
          timestamp: 'Just now',
          likes: 0,
        ));
        _thread.comments++;
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.vsBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Thread',
          style: TextStyle(
            color: AppTheme.vsBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Thread Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(_thread.userAvatar),
                            radius: 25,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _thread.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _thread.timestamp,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Thread Content
                      Text(
                        _thread.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      
                      // Tags
                      if (_thread.tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Wrap(
                            spacing: 8,
                            children: _thread.tags.map((tag) {
                              return Text(
                                '#$tag',
                                style: TextStyle(
                                  color: AppTheme.vsBlue,
                                  fontSize: 14,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      
                      // Interaction Counts
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              '${_thread.likes} Likes',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${_thread.comments} Comments',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ),
                      
                      // Interaction Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInteractionButton(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            _thread.likes.toString(),
                            _toggleLike,
                            color: _isLiked ? Colors.red : Colors.white,
                          ),
                          _buildInteractionButton(
                            Icons.comment_outlined,
                            _thread.comments.toString(),
                            () {}, // Already on comments screen
                          ),
                          _buildInteractionButton(
                            Icons.repeat,
                            _thread.reposts.toString(),
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Reposted!')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Comments Divider
                Divider(color: Colors.grey[700], thickness: 1),
                
                // Comments List
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return _CommentCard(comment: comment);
                  },
                ),
              ],
            ),
          ),
          
          // Comment Input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(
    IconData icon, 
    String count, 
    VoidCallback onPressed, 
    {Color color = Colors.white}
  ) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Container(
      color: AppTheme.secondaryBlack,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.vsBlue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.vsBlue),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: AppTheme.vsBlue),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final CommentModel comment;

  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'), // TODO: Replace with actual avatar
        radius: 20,
      ),
      title: Text(
        comment.username,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.content,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                comment.timestamp,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              const SizedBox(width: 16),
              Text(
                '${comment.likes} Likes',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Add these to your thread_model.dart if not already present
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