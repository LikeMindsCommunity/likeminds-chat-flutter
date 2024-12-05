import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chatbot_flutter_sample/onboarding/cred_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_chatbot_flutter_sample/main.dart';

class LMChatbotApp extends StatelessWidget {
  const LMChatbotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      toastTheme: ToastThemeData(
        background: Colors.black.withOpacity(0.6),
        textColor: Colors.white,
      ),
      child: MaterialApp(
        navigatorKey: rootNavigatorKey,
        title: 'Chat App for UI + SDK package',
        debugShowCheckedModeBanner: isDebug,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const CredScreen(),
      ),
    );
  }
}

class LMChatbotHomeScreen extends StatefulWidget {
  final String? apiKey;

  final String? uuid;

  final String? userName;

  const LMChatbotHomeScreen({
    super.key,
    this.apiKey,
    this.uuid,
    this.userName,
  });

  @override
  State<LMChatbotHomeScreen> createState() => _LMChatbotHomeScreenState();
}

class _LMChatbotHomeScreenState extends State<LMChatbotHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 15,
            backgroundColor: Colors.teal,
            child: Text(
              'NT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 12,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 12, bottom: 12),
        child: LMChatAIButton(
          props: LMChatAIButtonProps(
            apiKey: widget.apiKey,
            uuid: widget.uuid,
            userName: widget.userName,
          ),
        ),
      ),
    );
  }
}
