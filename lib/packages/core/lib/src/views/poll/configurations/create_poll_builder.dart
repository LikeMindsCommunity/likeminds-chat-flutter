import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// {@template lm_chat_create_poll_builder}
/// [LMChatCreatePollBuilderDelegate] is a class which is used to build the create poll
/// screen. It is used to customize the create poll screen.
/// {@endtemplate}
class LMChatCreatePollBuilderDelegate {
  /// {@macro lm_chat_create_poll_builder}
  const LMChatCreatePollBuilderDelegate();

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
    LMChatWidgetSource source = LMChatWidgetSource.createPoll,
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
    StreamController<bool> isPollValid,
    bool Function() validatePoll,
    VoidCallback onPollSubmit,
  ) {
    return appBar;
  }

  /// user tile builder
  Widget userTileBuilder(
    BuildContext context,
    LMChatUserTile userTile,
  ) {
    return userTile;
  }

  Widget pollQuestionContainerBuilder(
    BuildContext context,
    TextEditingController controller,
    Container container,
  ) {
    return container;
  }

  Widget pollQuestionTitleBuilder(
    BuildContext context,
    LMChatText title,
  ) {
    return title;
  }

  Widget pollQuestionTextFieldBuilder(
    BuildContext context,
    TextEditingController controller,
    TextField textField,
  ) {
    return textField;
  }

  Widget pollOptionsListBuilder(
    BuildContext context,
    Widget optionList,
  ) {
    return optionList;
  }

  Widget pollOptionTitleBuilder(
    BuildContext context,
    LMChatText title,
  ) {
    return title;
  }

  Widget pollOptionTileBuilder(
    BuildContext context,
    LMChatOptionTile pollOption,
    int index,
  ) {
    return pollOption;
  }

  Widget addOptionTileBuilder(
    BuildContext context,
    LMChatTile addOptionTile,
  ) {
    return addOptionTile;
  }

  Widget advancedOptionBuilder(BuildContext context, Widget advancedOption) {
    return advancedOption;
  }

  Widget showResultsWithoutVotingTileBuilder(
    BuildContext context,
    SwitchListTile showResultsTile,
    bool value,
  ) {
    return showResultsTile;
  }

  Widget hideResultsTileBuilder(
    BuildContext context,
    SwitchListTile hideResultsTile,
    bool value,
  ) {
    return hideResultsTile;
  }

  Widget allowAddOptionTileBuilder(
    BuildContext context,
    SwitchListTile allowAddOptionTile,
    bool value,
  ) {
    return allowAddOptionTile;
  }

  Widget allowVoteChangeTileBuilder(
    BuildContext context,
    SwitchListTile allowVoteChangeTile,
    bool value,
  ) {
    return allowVoteChangeTile;
  }

  Widget anonymousPollTileBuilder(
    BuildContext context,
    SwitchListTile anonymousPollTile,
    bool value,
  ) {
    return anonymousPollTile;
  }

  Widget multipleSelectTextBuilder(
    BuildContext context,
    LMChatText multipleSelectText,
  ) {
    return multipleSelectText;
  }

  Widget expiryTimeContainerBuilder(
    BuildContext context,
    Container container,
  ) {
    return container;
  }

  Widget expiryTimeTitleBuilder(
    BuildContext context,
    LMChatText title,
  ) {
    return title;
  }

  Widget expiryTimeIconBuilder(
    BuildContext context,
    LMChatIcon icon,
  ) {
    return icon;
  }

  Widget expiryTimeTextBuilder(
    BuildContext context,
    LMChatText text,
  ) {
    return text;
  }
}
