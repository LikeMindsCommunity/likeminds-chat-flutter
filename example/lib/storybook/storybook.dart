import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class StoryBookApp extends StatefulWidget {
  const StoryBookApp({super.key});

  @override
  State<StoryBookApp> createState() => _StoryBookAppState();
}

class _StoryBookAppState extends State<StoryBookApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StoryBookPage(),
    );
  }
}

class StoryBookPage extends StatefulWidget {
  const StoryBookPage({super.key});

  @override
  State<StoryBookPage> createState() => _StoryBookPageState();
}

class _StoryBookPageState extends State<StoryBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: iconStory(),
      ),
    );
  }
}

LMChatText textStory() {
  return const LMChatText(
    'Hello, World!',
    style: LMChatTextStyle(
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

LMChatIcon iconStory() {
  return const LMChatIcon(
    type: LMChatIconType.icon,
    icon: Icons.access_alarm,
    style: LMChatIconStyle(
      size: 48,
      boxSize: 48,
      color: Colors.red,
      backgroundColor: Colors.green,
    ),
  );
}
