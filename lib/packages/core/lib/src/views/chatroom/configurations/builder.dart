import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chatroom_builder}
/// [LMChatroomBuilderDelegate] is a class which is used to build the chatroom
/// screen. It is used to customize the chatroom screen.
/// {@endtemplate}
class LMChatroomBuilderDelegate {
  /// {@macro lm_chatroom_builder}
  const LMChatroomBuilderDelegate();

  /// chatWidgetBuilder
  static final LMChatWidgetBuilderDelegate _chatWidgetBuilderDelegate =
      LMChatCore.config.widgetBuilderDelegate;

  /// Builds the scaffold for the screen
  /// Builds a [Scaffold] widget with the given parameters.
  Widget scaffold({
    Key? key,
    bool extendBody = false,
    bool extendBodyBehindAppBar = false,
    PreferredSizeWidget? appBar,
    Widget? body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    List<Widget>? persistentFooterButtons,
    AlignmentDirectional persistentFooterAlignment =
        AlignmentDirectional.centerEnd,
    Widget? drawer,
    DrawerCallback? onDrawerChanged,
    Widget? endDrawer,
    DrawerCallback? onEndDrawerChanged,
    Color? drawerScrimColor,
    Color? backgroundColor,
    Widget? bottomNavigationBar,
    Widget? bottomSheet,
    bool? resizeToAvoidBottomInset,
    bool primary = true,
    DragStartBehavior drawerDragStartBehavior = DragStartBehavior.start,
    double? drawerEdgeDragWidth,
    bool drawerEnableOpenDragGesture = true,
    bool endDrawerEnableOpenDragGesture = true,
    String? restorationId,
    LMChatWidgetSource source = LMChatWidgetSource.home,
    bool canPop = true,
    Function(bool)? onPopInvoked,
  }) {
    return _chatWidgetBuilderDelegate.scaffold(
      key: key,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: persistentFooterAlignment,
      drawer: drawer,
      onDrawerChanged: onDrawerChanged,
      endDrawer: endDrawer,
      onEndDrawerChanged: onEndDrawerChanged,
      drawerScrimColor: drawerScrimColor,
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
    );
  }

  /// Builds the scroll to bottom button

  /// Builds the app bar.
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    LMChatRoomViewData chatroom,
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// Builds the sent chat bubble.
  Widget sentChatBubbleBuilder(
    BuildContext context,
    LMChatConversationViewData conversation,
    LMChatBubble bubble,
  ) {
    return bubble;
  }

  /// Builds the received chat bubble.
  Widget receivedChatBubbleBuilder(
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

  /// Builds the conversation list for group chatroom
  Widget conversationList(
    int chatroomId,
    LMChatConversationList conversationList,
  ) {
    return conversationList;
  }

  /// Builds the conversation list for DM chatroom
  Widget dmConversationList(
    int chatroomId,
    LMChatDMConversationList dmConversationList,
  ) {
    return dmConversationList;
  }

  /// Builds the floating action button for chatroom
  Widget floatingActionButton(LMChatButton floatingActionButton) {
    return floatingActionButton;
  }

  /// Builds the loading page widget.
  Widget loadingPageWidgetBuilder(
    BuildContext context,
    Widget loadingPageWidget,
  ) {
    return loadingPageWidget;
  }

  /// Builds the loading list widget.
  Widget loadingListWidgetBuilder(
    BuildContext context,
    Widget loadingListWidget,
  ) {
    return loadingListWidget;
  }

  /// Builds the empty list widget.
  Widget noItemInListWidgetBuilder(
    BuildContext context,
    Widget noItemInListWidget,
  ) {
    return noItemInListWidget;
  }

  /// Builds the paginated loading widget.
  Widget paginatedLoadingWidgetBuilder(
    BuildContext context,
    Widget paginatedLoadingWidget,
  ) {
    return paginatedLoadingWidget;
  }

  /// Builds the chat bar.
  Widget chatBarBuilder(
    BuildContext context,
    LMChatroomBar chatBar,
  ) {
    return chatBar;
  }

  /// Builds the chatroom text field.
  Widget chatroomTextField(
    BuildContext context,
    TextEditingController textController,
    LMChatTextField chatroomTextField,
  ) {
    return chatroomTextField;
  }

  /// Builds edit text field Header.
  Widget editTextTextFieldHeader(
    BuildContext context,
    TextEditingController textController,
    LMChatBarHeader chatBarHeader,
  ) {
    return chatBarHeader;
  }

  /// Builds the reply text field header.
  Widget replyTextFieldHeader(
    BuildContext context,
    TextEditingController textController,
    LMChatBarHeader chatBarHeader,
  ) {
    return chatBarHeader;
  }

  /// Builds the chatroom menu.
  Widget sendButton(
    BuildContext context,
    TextEditingController textController,
    VoidCallback onPressed,
    LMChatButton sendButton,
  ) {
    return sendButton;
  }

  /// Builds the chatroom menu
  Widget chatroomMenu(
    BuildContext context,
    List<ChatroomAction> chatroomActions,
    LMChatroomMenu chatroomMenu,
  ) {
    return chatroomMenu;
  }

  /// Builds the reply button. This button is used to reply to a message.
  Widget replyButton(
    BuildContext context,
    LMChatConversationViewData conversation,
    LMChatButton replyButton,
  ) {
    return replyButton;
  }

  /// Builds the edit button. This button is used to edit a message.
  Widget editButton(
    BuildContext context,
    LMChatConversationViewData conversation,
    LMChatButton editButton,
  ) {
    return editButton;
  }

  /// Builds the copy button. This button is used to copy a message.
  Widget copyButton(
    BuildContext context,
    List<LMChatConversationViewData> conversations,
    LMChatButton copyButton,
  ) {
    return copyButton;
  }

  /// Builds the delete button. This button is used to delete a message.
  Widget deleteButton(
    BuildContext context,
    LMChatConversationViewData conversation,
    LMChatButton deleteButton,
  ) {
    return deleteButton;
  }

  /// Builds the more option button. This button is used to show more options.
  Widget moreOptionButton(
    BuildContext context,
    Function(LMChatConversationViewData conversation) onTap,
    Widget moreOptionButton,
  ) {
    return moreOptionButton;
  }
}
