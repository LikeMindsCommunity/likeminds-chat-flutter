import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that represents a List of DM Chatrooms
/// Talks to an instance of LMChatDMFeedBloc, and updates accordingly
/// Allows for customizations to change the look and feel.
class LMChatDMFeedList extends StatefulWidget {
  const LMChatDMFeedList({super.key});

  @override
  State<LMChatDMFeedList> createState() => _LMChatDMFeedListState();
}

class _LMChatDMFeedListState extends State<LMChatDMFeedList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
