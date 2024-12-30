import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMessageItem(
          'John Doe',
          'Hey, great stream yesterday!',
          '2m ago',
        ),
        _buildMessageItem(
          'Jane Smith',
          'When is your next live session?',
          '1h ago',
        ),
      ],
    );
  }

  Widget _buildMessageItem(String name, String message, String time) {
    return Card(
      color: AppTheme.surfaceBlack,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.vsBlue,
          child: Text(name[0]),
        ),
        title: Text(name),
        subtitle: Text(message),
        trailing: Text(time),
      ),
    );
  }
}