import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.live_tv,
            size: 64,
            color: AppTheme.vsLightBlue,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement go live functionality
            },
            child: const Text('Start Streaming'),
          ),
        ],
      ),
    );
  }
}