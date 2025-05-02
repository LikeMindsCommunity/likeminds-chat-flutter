import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_community_hybrid_chat_builder_delegate}
/// [LMCommunityHybridChatBuilderDelegate] is a class which is used to build the LMCommunityHybridChatScreen.
///  It is used to customize the LMCommunityHybridChatScreen.
/// To customize the LMCommunityHybridChatScreen, create a class that extends
/// [LMCommunityHybridChatBuilderDelegate] and override the methods.
/// Then pass the instance of this class to the [LMCommunityHybridChatScreen] class.
/// which is used to configure the LMCommunityHybridChatScreen.
///
/// example:
/// ```dart
/// class ExampleHomeBuilder extends LMCommunityHybridChatBuilderDelegate {
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
/// Then pass the instance of this class to the [LMCommunityHybridChatScreen] class.
/// ```dart
/// LMCommunityHybridChatScreen(
///  builder: ExampleHomeBuilder(),
///   );
/// ```
/// Use This [LMCommunityHybridChatConfig] instance to configure the LMCommunityHybridChatScreen
/// by passing it to the [LMChatCore] class. in initialize method.
/// ```dart
/// LMChatCore.instance.initialize(
///   config: LMChatConfig(
///     config: LMChatConfig(
///      communityHybridChatConfig: LMCommunityHybridChatConfig(
///        builder: ExampleHomeBuilder(),
///      ),
///    ),
/// );
/// ```
/// {@endtemplate}
class LMCommunityHybridChatBuilderDelegate {
  /// {@macro lm_community_hybrid_chat_builder_delegate}
  const LMCommunityHybridChatBuilderDelegate();

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

  /// Builds [AppBar] widget for LMCommunityHybridChatScreen
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    LMChatUserViewData userViewData,
    TabController tabController,
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// Builds [TabBar] widget for LMCommunityHybridChatScreen
  PreferredSizeWidget tabBarBuilder(
    BuildContext context,
    TabController tabController,
    TabBar tabBar,
  ) {
    return tabBar;
  }
}
