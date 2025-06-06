import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// {@template lm_member_list_builder}
/// [LMChatMemberListBuilderDelegate] is a class which is used to build the member list
/// screen. It is used to customize the member list screen.
/// {@endtemplate}
class LMChatMemberListBuilderDelegate {
  /// {@macro lm_member_list_builder}
  const LMChatMemberListBuilderDelegate();

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
    LMChatWidgetSource source = LMChatWidgetSource.participants,
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

  /// Builds the app bar.
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    LMChatAppBar appBar,
    bool isSearching,
    TextEditingController searchController,
    Function(String text) onSearch,
    VoidCallback onClear,
  ) {
    return appBar;
  }

  /// user tile builder
  Widget userTileBuilder(
    BuildContext context,
    LMChatUserViewData user,
    LMChatUserTile userTile,
    Function(int? chatroomId) navigateToChatroom,
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

  Widget rateLimitDialog(
      BuildContext context, int? newTime, LMChatDialog defRateLimitDialog) {
    return defRateLimitDialog;
  }
}
