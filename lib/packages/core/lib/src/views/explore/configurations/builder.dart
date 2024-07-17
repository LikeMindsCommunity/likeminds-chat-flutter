import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_explore_builder_delegate}
/// [LMChatExploreBuilderDelegate] is a class which is used to build the explore
/// screen. It is used to customize the explore screen.
/// {@endtemplate}
class LMChatExploreBuilderDelegate {
  /// {@macro lm_chat_explore_builder_delegate}
  const LMChatExploreBuilderDelegate();

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

  /// Builds the app bar.
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// Builds the explore tile
  Widget exploreTileBuilder(
    BuildContext context,
    LMChatRoomViewData chatRoomViewData,
    LMChatExploreTile tile,
  ) {
    return tile;
  }

  /// Builds the explore menu
  Widget exploreMenuBuilder(
    BuildContext context,
    VoidCallback onNewestTap,
    VoidCallback onRecentlyActiveTap,
    VoidCallback onMostParticipantsTap,
    VoidCallback onMostMessagesTap,
    CustomPopupMenu menu,
  ) {
    return menu;
  }

  /// Builds Pin Button
  Widget pinButtonBuilder(
    BuildContext context,
    LMChatButton pinButton,
  ) {
    return pinButton;
  }

  /// Builds Pinned Button
  Widget pinnedButtonBuilder(
    BuildContext context,
    LMChatButton pinnedButton,
  ) {
    return pinnedButton;
  }

  /// Builds pin icon on the explore tile avatar
  Widget pinIconBuilder(
    BuildContext context,
    LMChatIcon pinIcon,
  ) {
    return pinIcon;
  }

  /// Builds header for the explore screen tile
  Widget headerBuilder(
    BuildContext context,
    LMChatText header,
  ) {
    return header;
  }

  /// Builds the lock icon in case of secret chatroom
  Widget lockIconBuilder(
    BuildContext context,
    LMChatIcon lockIcon,
  ) {
    return lockIcon;
  }

  /// Builds the subtitle for the explore screen tile
  Widget subtitleBuilder(
    BuildContext context,
    LMChatText subtitle,
  ) {
    return subtitle;
  }

  /// Builds the member count for the explore screen tile
  Widget memberCountBuilder(
    BuildContext context,
    int memberCount,
    LMChatText memberCountText,
  ) {
    return memberCountText;
  }

  /// Builds the member count icon for the explore screen tile
  Widget memberCountIconBuilder(
    BuildContext context,
    LMChatIcon memberCountIcon,
  ) {
    return memberCountIcon;
  }

  /// Builds the unread count for the explore screen tile
  Widget totalResponseCountBuilder(
    BuildContext context,
    int totalResponseCount,
    LMChatText totalResponseCountText,
  ) {
    return totalResponseCountText;
  }

  /// Builds the unread count icon for the explore screen tile
  Widget totalResponseCountIconBuilder(
    BuildContext context,
    LMChatIcon totalResponseCountIcon,
  ) {
    return totalResponseCountIcon;
  }
}
