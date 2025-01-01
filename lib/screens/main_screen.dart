import 'package:flutter/material.dart';
import '../widgets/video_post_card.dart';
import '../models/video_model.dart';
import '../themes/app_theme.dart';
import '../screens/videos_screen.dart';
import '../screens/live_screen.dart';
import '../screens/inbox_screen.dart';
import '../screens/threads_screen.dart';  // Add this import


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          VideosScreen(),
          ThreadsScreen(),  // Replace the Center widget with ThreadsScreen
          LiveScreen(),
          InboxScreen(),
          Center(
            child: Text(
              'Profile',
              style: TextStyle(color: AppTheme.vsLightBlue, fontSize: 24),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.pureBlack,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: NavigationBar(
          height: 65,
          backgroundColor: Colors.transparent,
          indicatorColor: AppTheme.vsGrey.withOpacity(0.3),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.video_library_outlined, 
                color: _currentIndex == 0 ? AppTheme.vsBlue : Colors.white.withOpacity(0.8)),
              selectedIcon: Icon(Icons.video_library, color: AppTheme.vsBlue),
              label: 'Videos',
            ),
            NavigationDestination(
              icon: Icon(Icons.forum_outlined,
                color: _currentIndex == 1 ? AppTheme.vsBlue : Colors.white.withOpacity(0.8)),
              selectedIcon: Icon(Icons.forum, color: AppTheme.vsBlue),
              label: 'Threads',
            ),
            NavigationDestination(
              icon: Icon(Icons.live_tv_outlined,
                color: _currentIndex == 2 ? AppTheme.vsBlue : Colors.white.withOpacity(0.8)),
              selectedIcon: Icon(Icons.live_tv, color: AppTheme.vsBlue),
              label: 'Live',
            ),
            NavigationDestination(
              icon: Icon(Icons.inbox_outlined,
                color: _currentIndex == 3 ? AppTheme.vsBlue : Colors.white.withOpacity(0.8)),
              selectedIcon: Icon(Icons.inbox, color: AppTheme.vsBlue),
              label: 'Inbox',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline,
                color: _currentIndex == 4 ? AppTheme.vsBlue : Colors.white.withOpacity(0.8)),
              selectedIcon: Icon(Icons.person, color: AppTheme.vsBlue),
              label: 'Profile',
            ),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }
}