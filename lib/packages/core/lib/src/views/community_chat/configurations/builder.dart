import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// {@template lm_community_chat_builder_delegate}
/// [LMCommunityChatBuilderDelegate] is a class which is used to build the home
/// screen. It is used to customize the home screen.
/// To customize the home screen, create a class that extends
/// [LMCommunityChatBuilderDelegate] and override the methods.
/// Then pass the instance of this class to the [LMChatHomeConfig] class.
/// which is used to configure the home screen.
///
/// example:
/// ```dart
/// class ExampleHomeBuilder extends LMCommunityChatBuilderDelegate {
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
class LMCommunityChatBuilderDelegate {
  /// {@macro lm_chat_home_builder_delegate}
  const LMCommunityChatBuilderDelegate();

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
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// Builds a home feed chatroom tile
  Widget chatroomTileBuilder(
    BuildContext context,
    LMChatRoomViewData chatroom,
    LMChatTile tile,
  ) {
    return tile;
  }

  /// Builds a home feed explore tile
  Widget exploreTileBuilder(
    BuildContext context,
    LMChatTile tile,
  ) {
    return tile;
  }

  /// Builds the explore chip
  Widget exploreChipBuilder(
    BuildContext context,
    LMChatChip chip,
  ) {
    return chip;
  }

  /// Builds mute icon in home feed
  Widget muteIconBuilder(LMChatIcon icon) {
    return icon;
  }

  /// Builds search icon in home feed
  Widget secretChatroomIconBuilder(LMChatIcon icon) {
    return icon;
  }

  /// Builds the first page error indicator.
  Widget firstPageErrorIndicatorBuilder(
    BuildContext context,
    Widget errorWidget,
  ) {
    return errorWidget;
  }

  /// Builds the new page error indicator.
  Widget newPageErrorIndicatorBuilder(
    BuildContext context,
    Widget errorWidget,
  ) {
    return errorWidget;
  }

  /// Builds the first page progress indicator.
  Widget firstPageProgressIndicatorBuilder(
    BuildContext context,
    Widget loaderWidget,
  ) {
    return loaderWidget;
  }

  /// Builds the new page progress indicator.
  Widget newPageProgressIndicatorBuilder(
    BuildContext context,
    Widget loaderWidget,
  ) {
    return loaderWidget;
  }

  /// Builds the no items found indicator.
  Widget noItemsFoundIndicatorBuilder(
    BuildContext context,
    Widget noItemsFoundWidget,
  ) {
    return noItemsFoundWidget;
  }

  /// Builds the no more items indicator.
  Widget noMoreItemsIndicatorBuilder(
    BuildContext context,
    Widget noMoreItemsWidget,
  ) {
    return noMoreItemsWidget;
  }
 }
