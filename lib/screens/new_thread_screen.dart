import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../models/thread_model.dart';

class NewThreadScreen extends StatefulWidget {
  const NewThreadScreen({Key? key}) : super(key: key);

  @override
  _NewThreadScreenState createState() => _NewThreadScreenState();
}

class _NewThreadScreenState extends State<NewThreadScreen> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  
  // Available tags for selection
  final List<String> _availableTags = [
    'Programming',
    'Design',
    'Tech',
    'Career',
    'Mobile',
    'AI',
    'Startup',
    'Web Development',
    'Data Science',
    'Product Management',
    'Cybersecurity',
    'Cloud Computing',
    'DevOps',
    'Machine Learning',
    'Blockchain',
    'UX/UI',
    'Freelancing',
    'Entrepreneurship',
    'Software Engineering',
    'Open Source'
  ];

  // Selected tags
  List<String> _selectedTags = [];

  // Expanded state for tags
  bool _isTagsExpanded = false;

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _createThread() {
    // Validate content
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thread content cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create a new thread
    final newThread = ThreadModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary unique ID
      username: '@currentUser', // TODO: Replace with actual logged-in user
      userAvatar: 'https://i.pravatar.cc/150?img=1', // TODO: Replace with actual user avatar
      content: _contentController.text.trim(),
      timestamp: 'Just now',
      likes: 0,
      comments: 0,
      reposts: 0,
      tags: _selectedTags,
    );

    // TODO: Actually save the thread (e.g., to a database or API)
    Navigator.of(context).pop(newThread);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppTheme.vsBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New Thread',
          style: TextStyle(
            color: AppTheme.vsBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _createThread,
            child: Text(
              'Post',
              style: TextStyle(
                color: AppTheme.vsBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User avatar and name (placeholder)
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
                          radius: 25,
                        ),
                        SizedBox(width: 12),
                        Text(
                          '@currentUser', // TODO: Replace with actual username
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Thread content input
                    TextField(
                      controller: _contentController,
                      focusNode: _contentFocusNode,
                      maxLines: null,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Start a thread...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                    
                    // Selected Tags Display
                    if (_selectedTags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedTags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: AppTheme.vsBlue.withOpacity(0.2),
                              deleteIcon: Icon(Icons.close, size: 18, color: AppTheme.vsBlue),
                              onDeleted: () => _toggleTag(tag),
                            );
                          }).toList(),
                        ),
                      ),

                    // Add Tags Button
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isTagsExpanded = !_isTagsExpanded;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryBlack,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add Tags',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              _isTagsExpanded 
                                ? Icons.keyboard_arrow_up 
                                : Icons.keyboard_arrow_down,
                              color: AppTheme.vsBlue,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Expandable Tags Section
                    if (_isTagsExpanded)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableTags.map((tag) {
                            final isSelected = _selectedTags.contains(tag);
                            return ChoiceChip(
                              label: Text(tag),
                              selected: isSelected,
                              onSelected: (_) => _toggleTag(tag),
                              selectedColor: AppTheme.vsBlue.withOpacity(0.2),
                              backgroundColor: AppTheme.secondaryBlack,
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.vsBlue : Colors.white,
                              ),
                              side: BorderSide(
                                color: isSelected 
                                  ? AppTheme.vsBlue 
                                  : AppTheme.vsGrey.withOpacity(0.3),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Optional: Bottom bar for additional actions like media upload
          Container(
            color: AppTheme.secondaryBlack,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_photo_alternate, color: AppTheme.vsBlue),
                  onPressed: () {
                    // TODO: Implement media upload
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Media upload coming soon!')),
                    );
                  },
                ),
                Spacer(),
                Text(
                  '${_contentController.text.length}/280', // Optional character limit
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}