import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_conversation_action_interface}
/// The interface for the chat conversation actions.
/// {@endtemplate}
abstract class LMChatConversationActionInterface {
  /// The function to call when a reply is made.
  void onReply(LMChatConversationViewData conversation);

  /// The function to call when a copy is made.
  void onCopy(List<LMChatConversationViewData> conversations);

  /// The function to call when an edit is made.
  void onEdit(LMChatConversationViewData conversation);

  /// The function to call when a delete is made.
  void onDelete(BuildContext context, List<int> conversationIds);

  /// The function to call when a report is made.
  void onReport(LMChatConversationViewData conversation, BuildContext context);

  /// The function to call when a reaction is made.
  void onReaction();

  /// The function to call when the menu is shown.
  void showSelectionMenu(BuildContext context, Offset? position);
}
