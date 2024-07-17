import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_home_builder_delegate}
/// [LMChatHomeBuilderDelegate] is a class which is used to build the home
/// screen. It is used to customize the home screen.
/// To customize the home screen, create a class that extends
/// [LMChatHomeBuilderDelegate] and override the methods.
/// Then pass the instance of this class to the [LMChatHomeConfig] class.
/// which is used to configure the home screen.
///
/// example:
/// ```dart
/// class ExampleHomeBuilder extends LMChatHomeBuilderDelegate {
///  @override
///  appBarBuilder(BuildContext context, LMChatAppBar appBar) {
///   return appBar.copyWith(
///    style: LMChatAppBarStyle.basic().copyWith(
///     backgroundColor: Colors.green,
///       ),
///     );
///   }
/// }
/// ```
/// Then pass the instance of this class to the [LMChatHomeConfig] class.
/// ```dart
/// LMChatHomeConfig(
///  builder: ExampleHomeBuilder(),
///   );
/// ```
/// Use This [LMChatHomeConfig] instance to configure the home screen
/// by passing it to the [LMChatCore] class. in initialize method.
/// ```dart
/// LMChatCore.instance.initialize(
///   config: LMChatConfig(
///     config: LMChatConfig(
///      homeConfig: LMChatHomeConfig(
///        builder: ExampleHomeBuilder(),
///      ),
///    ),
/// );
/// ```
/// {@endtemplate}
class LMChatHomeBuilderDelegate {
  /// {@macro lm_chat_home_builder_delegate}
  const LMChatHomeBuilderDelegate();

  /// chatWidgetBuilder
  static final LMChatWidgetBuilderDelegate _chatWidgetBuilderDelegate =
      LMChatCore.config.widgetBuilderDelegate;

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

  /// Builds [AppBar] widget for home screen
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    LMChatUserViewData userViewData,
    TabController tabController,
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// Builds [TabBar] widget for home screen
  PreferredSizeWidget tabBarBuilder(
    BuildContext context,
    TabController tabController,
    TabBar tabBar,
  ) {
    return tabBar;
  }

  // Builders for home feed list

  /// Builds a home feed chatroom tile
  Widget homeFeedTileBuilder(
    BuildContext context,
    LMChatRoomViewData chatroom,
    LMChatTile tile,
  ) {
    return tile;
  }

/// Builds a home feed explore tile
  Widget homeFeedExploreTileBuilder(
    BuildContext context,
    LMChatTile tile,
  ) {
    return tile;
  }

  /// Builds the explore chip
  Widget homeFeedExploreChipBuilder(
    BuildContext context,
    LMChatChip chip,
  ) {
    return chip;
  }

  /// Builds mute icon in home feed
  Widget homeFeedMuteIconBuilder(LMChatIcon icon) {
    return icon;
  }

  /// Builds search icon in home feed
  Widget homeFeedSecretChatroomIconBuilder(LMChatIcon icon) {
    return icon;
  }

  /// Builds the first page error indicator.
  Widget homeFeedFirstPageErrorIndicatorBuilder(
    BuildContext context,
    Widget errorWidget,
  ) {
    return errorWidget;
  }

  /// Builds the new page error indicator.
  Widget homeFeedNewPageErrorIndicatorBuilder(
    BuildContext context,
    Widget errorWidget,
  ) {
    return errorWidget;
  }

  /// Builds the first page progress indicator.
  Widget homeFeedFirstPageProgressIndicatorBuilder(
    BuildContext context,
    Widget loaderWidget,
  ) {
    return loaderWidget;
  }

  /// Builds the new page progress indicator.
  Widget homeFeedNewPageProgressIndicatorBuilder(
    BuildContext context,
    Widget loaderWidget,
  ) {
    return loaderWidget;
  }

  /// Builds the no items found indicator.
  Widget homeFeedNoItemsFoundIndicatorBuilder(
    BuildContext context,
    Widget noItemsFoundWidget,
  ) {
    return noItemsFoundWidget;
  }

  /// Builds the no more items indicator.
  Widget homeFeedNoMoreItemsIndicatorBuilder(
    BuildContext context,
    Widget noMoreItemsWidget,
  ) {
    return noMoreItemsWidget;
  }

  // Builders for dm feed list

  /// Builds a dm feed chatroom tile
  Widget dmFeedTileBuilder(
    BuildContext context,
    LMChatRoomViewData chatroom,
    LMChatTile tile,
  ) {
    return tile;
  }

  /// Builds mute icon in dm feed
  Widget dmFeedMuteIconBuilder(LMChatIcon icon) {
    return icon;
  }

  /// Builds the first page error indicator.
  Widget dmFeedFirstPageErrorIndicatorBuilder(
    BuildContext context,
    Widget errorWidget,
  ) {
    return errorWidget;
  }

  /// Builds the new page error indicator.
  Widget dmFeedNewPageErrorIndicatorBuilder(
    BuildContext context,
    Widget errorWidget,
  ) {
    return errorWidget;
  }

  /// Builds the first page progress indicator.
  Widget dmFeedFirstPageProgressIndicatorBuilder(
    BuildContext context,
    Widget loaderWidget,
  ) {
    return loaderWidget;
  }

  /// Builds the new page progress indicator.
  Widget dmFeedNewPageProgressIndicatorBuilder(
    BuildContext context,
    Widget loaderWidget,
  ) {
    return loaderWidget;
  }

  /// Builds the no items found indicator.

  Widget dmFeedNoItemsFoundIndicatorBuilder(
    BuildContext context,
    Widget noItemsFoundWidget,
  ) {
    return noItemsFoundWidget;
  }

  /// Builds the no more items indicator.
  Widget dmFeedNoMoreItemsIndicatorBuilder(
    BuildContext context,
    Widget noMoreItemsWidget,
  ) {
    return noMoreItemsWidget;
  }
}
