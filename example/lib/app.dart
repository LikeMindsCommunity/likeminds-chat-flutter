import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_sample/onboarding/cred_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_chat_flutter_sample/main.dart';

class LMChatSampleApp extends StatelessWidget {
  const LMChatSampleApp({super.key});

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        ),
        home: const CredScreen(),
      ),
    );
  }
}
