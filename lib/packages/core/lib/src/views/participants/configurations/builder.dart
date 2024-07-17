import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_participant_builder_delegate}
/// Delegate class for building the participant widget
/// {@endtemplate}
class LMChatParticipantBuilderDelegate {
  /// {@macro lm_chat_participant_builder_delegate}
  const LMChatParticipantBuilderDelegate();
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

  /// Builds the first page error indicator.
  Widget firstPageErrorIndicatorBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }

  /// Builds the new page error indicator.
  Widget newPageErrorIndicatorBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }

  /// Builds the first page progress indicator.
  Widget firstPageProgressIndicatorBuilder(
    BuildContext context,
  ) {
    LMChatThemeData chatThemeData = LMChatTheme.instance.themeData;
    return LMChatLoader(
      style: chatThemeData.loaderStyle,
    );
  }

  /// Builds the new page progress indicator.
  Widget newPageProgressIndicatorBuilder(
    BuildContext context,
  ) {
    LMChatThemeData chatThemeData = LMChatTheme.instance.themeData;
    return LMChatLoader(
      style: chatThemeData.loaderStyle,
    );
  }

  /// Builds the no items found indicator.
  Widget noItemsFoundIndicatorBuilder(
    BuildContext context,
  ) {
    return const Center(
      child: LMChatText(
        'No search results found',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// Builds the no more items indicator.
  Widget noMoreItemsIndicatorBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }

  /// Builds the app bar.
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    TextEditingController searchController,
    VoidCallback onSearch,
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// Builds the list view.
  Widget userTileBuilder(
    BuildContext context,
    LMChatUserViewData user,
    LMChatUserTile userTile,
  ) {
    return userTile;
  }
}
