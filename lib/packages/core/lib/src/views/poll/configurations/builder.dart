import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// {@template lm_chat_poll_builder}
/// [LMChatPollBuilderDelegate] is a class which is used to build the chatroom
/// screen. It is used to customize the chatroom screen.
/// {@endtemplate}
class LMChatPollBuilderDelegate {
  /// {@macro lm_chat_poll_builder}
  const LMChatPollBuilderDelegate();

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
    LMChatWidgetSource source = LMChatWidgetSource.pollResult,
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
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// user tile builder
  Widget userTileBuilder(
    BuildContext context,
    LMChatUserViewData user,
    LMChatUserTile userTile,
  ) {
    return userTile;
  }

  /// no item builder
  Widget noItemsFoundIndicatorBuilder(
    BuildContext context,
    Widget noItemIndicator,
  ) {
    return noItemIndicator;
  }

  /// first page progress indicator builder
  Widget firstPageProgressIndicatorBuilder(
    BuildContext context,
    Widget firstPageProgressIndicator,
  ) {
    return firstPageProgressIndicator;
  }

  /// Error indicator builder
  Widget firstPageErrorIndicatorBuilder(
    BuildContext context,
    Widget firstPageErrorIndicator,
  ) {
    return firstPageErrorIndicator;
  }

  /// Builds the tab bar.
  Widget tabBarBuilder(
    BuildContext context,
    TabBar tabBar,
  ) {
    return tabBar;
  }

  /// Builds the vote count text in TabBar
  Widget voteCountTextBuilder(
    BuildContext context,
    LMChatText voteCountText,
  ) {
    return voteCountText;
  }

  /// Builds the poll option text in TabBar
  Widget pollOptionTextBuilder(
    BuildContext context,
    LMChatText pollOptionText,
  ) {
    return pollOptionText;
  }
}
