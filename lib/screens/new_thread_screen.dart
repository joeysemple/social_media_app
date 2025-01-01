import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  
  // Maximum character limit
  static const int _maxCharacters = 280;

  // Mock list of users for mentions
  final List<String> _availableUsers = [
    'techie', 'designerPro', 'codingNinja', 'mobileDevGuru', 
    'uiuxMaster', 'techCareer', 'openSourceHero', 
    'dataScientist', 'cloudEngineer', 'securityPro'
  ];

  // Mention tracking
  List<String> _mentionedUsers = [];

  // Image selection
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];

  // Available tags for selection
  final List<String> _availableTags = [
    'Programming', 'Design', 'Tech', 'Career', 'Mobile', 'AI', 'Startup', 
    'Web Development', 'Data Science', 'Product Management', 'Cybersecurity', 
    'Cloud Computing', 'DevOps', 'Machine Learning', 'Blockchain', 'UX/UI', 
    'Freelancing', 'Entrepreneurship', 'Software Engineering', 'Open Source'
  ];

  // Selected tags
  List<String> _selectedTags = [];

  // Expanded state for tags
  bool _isTagsExpanded = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _contentController.removeListener(_onContentChanged);
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    setState(() {
      // Detect mentions
      _mentionedUsers = _detectMentions(_contentController.text);

      // Trim content if it exceeds max characters
      if (_contentController.text.length > _maxCharacters) {
        _contentController.text = _contentController.text.substring(0, _maxCharacters);
        _contentController.selection = TextSelection.fromPosition(
          TextPosition(offset: _maxCharacters),
        );
      }
    });
  }

  // Mention detection method
  List<String> _detectMentions(String text) {
    final mentionRegex = RegExp(r'@(\w+)');
    return mentionRegex.allMatches(text)
        .map((match) => match.group(1)!)
        .where((username) => _availableUsers.contains(username))
        .toList();
  }

  // Image selection method
  Future<void> _pickImages() async {
    // Limit to 4 images
    if (_selectedImages.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum 4 images allowed')),
      );
      return;
    }

    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );

    setState(() {
      // Add new images, ensuring total doesn't exceed 4
      for (var file in pickedFiles) {
        if (_selectedImages.length < 4) {
          _selectedImages.add(file);
        } else {
          break;
        }
      }
    });
  }

  // Remove image method
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
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
    final trimmedContent = _contentController.text.trim();
    if (trimmedContent.isEmpty && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thread content or image is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create a new thread
    final newThread = ThreadModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: '@currentUser', // TODO: Replace with actual logged-in user
      userAvatar: 'https://i.pravatar.cc/150?img=1', // TODO: Replace with actual user avatar
      content: trimmedContent,
      timestamp: 'Just now',
      likes: 0,
      comments: 0,
      reposts: 0,
      tags: _selectedTags,
    );

    // TODO: Actually save the thread and images (e.g., to a database or API)
    Navigator.of(context).pop(newThread);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate remaining characters
    final remainingChars = _maxCharacters - _contentController.text.length;
    final isOverLimit = remainingChars < 0;

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
            onPressed: remainingChars >= 0 ? _createThread : null,
            child: Text(
              'Post',
              style: TextStyle(
                color: remainingChars >= 0 ? AppTheme.vsBlue : Colors.grey,
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
                      style: TextStyle(
                        color: isOverLimit ? Colors.red : Colors.white, 
                        fontSize: 16
                      ),
                      decoration: InputDecoration(
                        hintText: 'Start a thread...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                    
                    // Character Count Indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '$remainingChars characters remaining',
                        style: TextStyle(
                          color: isOverLimit ? Colors.red : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    // Mentioned Users Display
                    if (_mentionedUsers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Mentioned: ${_mentionedUsers.map((user) => '@$user').join(', ')}',
                          style: TextStyle(
                            color: AppTheme.vsBlue,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    // Image Preview Section
                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(_selectedImages[index].path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.remove_circle, 
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _removeImage(index),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
          
          // Bottom bar for actions
          Container(
            color: AppTheme.secondaryBlack,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_photo_alternate, color: AppTheme.vsBlue),
                  onPressed: _pickImages,
                ),
                Spacer(),
                Text(
                  '${_contentController.text.length}/$_maxCharacters', // Character count
                  style: TextStyle(
                    color: isOverLimit ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}