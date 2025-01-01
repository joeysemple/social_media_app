import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class CategoryManagementScreen extends StatefulWidget {
  final List<String> currentCategories;

  const CategoryManagementScreen({
    Key? key, 
    required this.currentCategories
  }) : super(key: key);

  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  // Predefined list of all possible categories
  final List<String> _allCategories = [
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

  // Mutable list of selected categories
  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    // Initialize selected categories, preserving the existing selection
    // Exclude 'For You' and 'Following' from the selectable list
    _selectedCategories = List<String>.from(
      widget.currentCategories.where((category) => 
        category != 'For You' && 
        category != 'Following'
      )
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        title: Text(
          'Manage Categories',
          style: TextStyle(
            color: AppTheme.vsBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: AppTheme.vsBlue),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Return updated categories back to previous screen
              Navigator.of(context).pop([
                'For You',
                'Following',
                ..._selectedCategories
              ]);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Categories to Display',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,  // 2 columns
                childAspectRatio: 3,  // Width to height ratio
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _allCategories.length,
              itemBuilder: (context, index) {
                final category = _allCategories[index];
                final isSelected = _selectedCategories.contains(category);

                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => _toggleCategory(category),
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
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${_selectedCategories.length} categories selected',
              style: TextStyle(
                color: Colors.white54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}