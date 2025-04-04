import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';

/// {@template lm_search_builder}
/// [LMSearchBuilderDelegate] is a class used to build and customize the search
/// screen. It provides methods to override default widgets and behaviors.
/// {@endtemplate}
class LMSearchBuilderDelegate {
  /// {@macro lm_search_builder}
  const LMSearchBuilderDelegate();

  /// Default widget builder delegate for search-related widgets.
  static final LMChatWidgetBuilderDelegate _searchWidgetBuilderDelegate =
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
    return _searchWidgetBuilderDelegate.scaffold(
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

  /// Builds the back button
  Widget backButton(BuildContext context, LMChatButton backButton) {
    return backButton;
  }

  /// Builds the text field
  Widget searchField(
    BuildContext context,
    LMChatTextField textField,
  ) {
    return textField;
  }

  /// Builds the clear search button
  Widget clearSearchButton(
    BuildContext context,
    LMChatButton clearSearchButton,
  ) {
    return clearSearchButton;
  }

  /// Builds the user tile for a conversation in the search results.
  Widget userTile(
    BuildContext context,
    LMChatTile userTile,
  ) {
    return userTile;
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

  /// Builds the progress indicator for the first page.
  Widget firstPageProgressIndicatorBuilder(
    BuildContext context,
  ) {
    LMChatThemeData chatThemeData = LMChatTheme.instance.themeData;
    return LMChatLoader(
      style: chatThemeData.loaderStyle,
    );
  }

  /// Builds the progress indicator for a new page.
  Widget newPageProgressIndicatorBuilder(
    BuildContext context,
  ) {
    LMChatThemeData chatThemeData = LMChatTheme.instance.themeData;
    return LMChatLoader(
      style: chatThemeData.loaderStyle,
    );
  }

  /// Builds the "no items found" indicator when no results are found.
  Widget noItemsFoundIndicatorBuilder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LMChatIcon(
            type: LMChatIconType.svg,
            assetPath: emptyResultIcon,
            style: LMChatIconStyle(
              size: 40,
              margin: EdgeInsets.only(bottom: 16),
            ),
          ),
          LMChatText(
            'No results found',
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: LMChatTheme.theme.onContainer,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Builds the "empty text" indicator when the search input is empty.
  Widget emptyTextIndicatorBuilder() {
    return const Center(
      child: LMChatText(
        'Type to search',
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
}
