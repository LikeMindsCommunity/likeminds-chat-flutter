import 'package:flutter/material.dart';

/// {@template lm_chat_media_forwarding_screen}
/// A screen to preview media before attaching of LMChat
///
/// Creates a new instance for [LMChatMediaForwardingScreen]
///
/// Gives access to customizations through instance builder variables
///
/// To configure the page, use [LMChatMediaForwardingScreenConfig]
/// {@endtemplate}
class LMChatMediaForwardingScreen extends StatefulWidget {
  const LMChatMediaForwardingScreen({super.key});

  @override
  State<LMChatMediaForwardingScreen> createState() =>
      _LMChatMediaForwardingScreenState();
}

class _LMChatMediaForwardingScreenState
    extends State<LMChatMediaForwardingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
