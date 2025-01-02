import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'Nearby';
  String? selectedCountry;
  final List<String> _categories = ['Nearby', 'Explore', 'Popular', 'Game', 'Other'];

  Widget _buildLiveStreamCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.vsGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stream Preview
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.vsGrey,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: const Icon(
                    Icons.live_tv,
                    color: AppTheme.vsLightBlue,
                    size: 40,
                  ),
                ),
                // Viewer count
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.remove_red_eye, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '1.2K',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Live indicator
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Streamer Info
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.vsGrey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Stream Title',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedCategory == 'Explore') {
      final Map<String, List<Map<String, String>>> continentCountries = {
        'Asia': [
          {'name': 'Japan', 'flag': '🇯🇵'},
          {'name': 'South Korea', 'flag': '🇰🇷'},
          {'name': 'China', 'flag': '🇨🇳'},
          {'name': 'Thailand', 'flag': '🇹🇭'},
          {'name': 'Vietnam', 'flag': '🇻🇳'},
          {'name': 'Philippines', 'flag': '🇵🇭'},
          {'name': 'Indonesia', 'flag': '🇮🇩'},
          {'name': 'Malaysia', 'flag': '🇲🇾'},
          {'name': 'Singapore', 'flag': '🇸🇬'},
          {'name': 'India', 'flag': '🇮🇳'},
        ],
        'America': [
          {'name': 'United States', 'flag': '🇺🇸'},
          {'name': 'Canada', 'flag': '🇨🇦'},
          {'name': 'Mexico', 'flag': '🇲🇽'},
          {'name': 'Brazil', 'flag': '🇧🇷'},
          {'name': 'Argentina', 'flag': '🇦🇷'},
          {'name': 'Colombia', 'flag': '🇨🇴'},
          {'name': 'Chile', 'flag': '🇨🇱'},
          {'name': 'Peru', 'flag': '🇵🇪'},
        ],
        'Europe': [
          {'name': 'United Kingdom', 'flag': '🇬🇧'},
          {'name': 'France', 'flag': '🇫🇷'},
          {'name': 'Germany', 'flag': '🇩🇪'},
          {'name': 'Italy', 'flag': '🇮🇹'},
          {'name': 'Spain', 'flag': '🇪🇸'},
          {'name': 'Netherlands', 'flag': '🇳🇱'},
          {'name': 'Sweden', 'flag': '🇸🇪'},
          {'name': 'Norway', 'flag': '🇳🇴'},
        ],
        'Africa': [
          {'name': 'South Africa', 'flag': '🇿🇦'},
          {'name': 'Egypt', 'flag': '🇪🇬'},
          {'name': 'Nigeria', 'flag': '🇳🇬'},
          {'name': 'Kenya', 'flag': '🇰🇪'},
          {'name': 'Morocco', 'flag': '🇲🇦'},
          {'name': 'Ghana', 'flag': '🇬🇭'},
          {'name': 'Tanzania', 'flag': '🇹🇿'},
          {'name': 'Ethiopia', 'flag': '🇪🇹'},
        ],
      };

      if (selectedCountry != null) {
        // Show streams for selected country
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        selectedCountry = null;
                      });
                    },
                  ),
                  Text(
                    selectedCountry!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) => _buildLiveStreamCard(),
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: continentCountries.length,
        itemBuilder: (context, index) {
          String continent = continentCountries.keys.elementAt(index);
          List<Map<String, String>> countries = continentCountries[continent]!;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  continent,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: countries.length,
                itemBuilder: (context, countryIndex) {
                  final country = countries[countryIndex];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedCountry = country['name'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.vsGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.vsGrey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            country['flag']!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              country['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16), // Spacing between continents
            ],
          );
        },
      );
    } else if (_selectedCategory == 'Nearby') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'New York City', // Replace with actual location
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 10,
              itemBuilder: (context, index) => _buildLiveStreamCard(),
            ),
          ),
        ],
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 20,
        itemBuilder: (context, index) => _buildLiveStreamCard(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: AppTheme.primaryBlack,
            pinned: true,
            title: Text(
              'LIVE',
              style: TextStyle(
                color: AppTheme.vsBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: AppTheme.vsBlue),
                onPressed: () {
                  // Implement search functionality
                },
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
                            if (_selectedCategory != 'Explore') {
                              selectedCountry = null;
                            }
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
        body: _buildContent(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.vsBlue,
        onPressed: () {
          // TODO: Implement go live functionality
        },
        child: const Icon(Icons.videocam, color: Colors.white),
      ),
    );
  }
}