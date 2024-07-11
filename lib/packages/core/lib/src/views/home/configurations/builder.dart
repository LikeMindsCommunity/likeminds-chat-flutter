import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_home_builder_delegate}
/// [LMChatHomeBuilderDelegate] is a class which is used to build the home
/// screen. It is used to customize the home screen.
/// To customize the home screen, create a class that extends
/// [LMChatHomeBuilderDelegate] and override the methods.
/// Then pass the instance of this class to the [LMChatHomeConfig] class.
/// which is used to configure the home screen.
/// example:
/// ```dart
/// class ExampleHomeBuilder extends LMChatHomeBuilderDelegate {
///  @override
///  appBarBuilder(BuildContext context, LMChatAppBar appBar) {
///   return appBar.copyWith(
///    style: LMChatAppBarStyle.basic().copyWith(
///     backgroundColor: Colors.green,
///   ),
/// );
/// }
/// }
/// ```
/// Then pass the instance of this class to the [LMChatHomeConfig] class.
/// ```dart
/// LMChatHomeConfig(
///  builder: ExampleHomeBuilder(),
/// );
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
    LMChatAppBar appBar,
  ) {
    return appBar.copyWith(bottom: appBar.bottom);
  }

  /// Builds [LMChatHomeFeedList] widget for home screen
  Widget homeFeedListBuilder(
    BuildContext context,
    LMChatHomeFeedList feedList,
  ) {
    return feedList;
  }

  /// Builds [LMChatDMFeedList] widget for home screen
  Widget dmFeedListBuilder(
    BuildContext context,
    LMChatDMFeedList dmFeedList,
  ) {
    return dmFeedList;
  }
}
