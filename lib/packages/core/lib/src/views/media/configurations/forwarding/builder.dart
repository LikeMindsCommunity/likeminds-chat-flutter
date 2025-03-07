import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_media_forwarding_builder_delegate}
/// Delegate class for building the widgets related to [LMChatMediaForwardingScreen]
/// {@endtemplate}
class LMChatMediaForwardingBuilderDelegate {
  /// {@macro lm_chat_media_forwarding_builder_delegate}
  const LMChatMediaForwardingBuilderDelegate();

  static final LMChatWidgetBuilderDelegate _chatWidgetBuilderDelegate =
      LMChatCore.config.widgetBuilderDelegate;

  /// Build a [Scaffold] widget with the given parameters
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
    LMChatWidgetSource source = LMChatWidgetSource.mediaForwarding,
    bool canPop = true,
    Function(bool)? onPopInvoked,
    SystemUiOverlayStyle? systemUiOverlay,
  }) {
    return _chatWidgetBuilderDelegate.scaffold(
      key: key,
      extendBody: extendBody,
      systemUiOverlay: systemUiOverlay,
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
      onPopInvoked: onPopInvoked,
      canPop: canPop,
    );
  }

  /// Builds the app bar.
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    LMChatAppBar appBar,
    int mediaLength,
    int index,
  ) {
    return appBar;
  }

  /// Builds the app bar.
  Widget mediaPreviewBuilder(
    BuildContext context,
    List<LMChatMediaModel> media,
    int index,
    Widget currentPreview,
  ) {
    return currentPreview;
  }

  /// Builds the whole container for the bottom bar
  /// which includes the chatroom text field, voice notes button and send button
  Widget chatroomBottomBarContainer(
    BuildContext context,
    Container chatroomBottomBar,
    LMChatButton sendButton,
    LMChatTextField chatroomTextField,
    LMChatButton attachmentButton,
  ) {
    return chatroomBottomBar;
  }

  /// Builds the chatroom text field.
  Widget chatroomTextField(
    BuildContext context,
    TextEditingController textController,
    LMChatTextField chatroomTextField,
    LMChatButton attachmentMenu,
  ) {
    return chatroomTextField;
  }

  /// Builds the chatroom bar send button
  Widget sendButton(
    BuildContext context,
    VoidCallback onSend,
    LMChatButton sendButton,
  ) {
    return sendButton;
  }

  /// Build the chatroom bar attachment button
  Widget attachmentButton(
    BuildContext context,
    LMChatButton attachmentButton,
  ) {
    return attachmentButton;
  }

  /// Builds the LMChatImage widget of the screen
  Widget image(
    BuildContext context,
    LMChatImage image,
  ) {
    return image;
  }

  /// Builds the LMChatImage widget of the screen
  Widget video(
    BuildContext context,
    LMChatVideo video,
  ) {
    return video;
  }

  /// Builds the LMChatDocumentPreview widget of the screen
  Widget document(
    BuildContext context,
    LMChatDocumentPreview document,
  ) {
    return document;
  }

  /// Builds the LMChatGIF widget of the screen
  Widget gif(
    BuildContext context,
    LMChatGIF gif,
  ) {
    return gif;
  }

  /// Builds the LMChatBarHeader reply widget of the keyboard on screen
  Widget replyWidget(
    BuildContext context,
    LMChatBarHeader reply,
  ) {
    return reply;
  }
}
