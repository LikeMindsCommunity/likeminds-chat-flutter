import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_bar.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chatroom_builder}
/// [LMChatroomBuilderDelegate] is a class which is used to build the chatroom
/// screen. It is used to customize the chatroom screen.
/// {@endtemplate}
class LMChatroomBuilderDelegate {
  /// {@macro lm_chatroom_builder}
  const LMChatroomBuilderDelegate();

  /// Builds the app bar.
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    LMChatRoomViewData chatroom,
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// Builds the chat bubble.
  Widget chatBubbleBuilder(
    BuildContext context,
    LMChatConversationViewData conversation,
    LMChatBubble bubble,
  ) {
    return bubble;
  }
  /// Builds the state bubble.
  Widget stateBubbleBuilder(
    BuildContext context,
    String message,
    LMChatStateBubble stateBubble,
  ) {
    return stateBubble;
  }
  /// Builds the loading page widget.
  Widget loadingPageWidgetBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }
  /// Builds the loading list widget.
  Widget loadingListWidgetBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }
  /// Builds the paginated loading widget.
  Widget paginatedLoadingWidgetBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }
  /// Builds the chat bar.
  Widget chatBarBuilder(
    BuildContext context,
    LMChatroomBar chatBar,
  ) {
    return chatBar;
  }
}
