import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/report.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_report_builder_delegate}
/// Delegate class for building the report widget
/// {@endtemplate}
class LMChatReportBuilderDelegate {
  /// {@macro lm_chat_report_builder_delegate}
  const LMChatReportBuilderDelegate();

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

  /// Builds the report chip.
  Widget reportChipBuilder(
    BuildContext context,
    LMChatReportTagViewData data,
    LMChatChip reportChip,
  ) {
    return reportChip;
  }

  /// Builds the report content.
  Widget reportContentBuilder(
    BuildContext context,
    LMReportContentWidget reportContentWidget,
  ) {
    return reportContentWidget;
  }

  /// Builds the other reason text field.
  Widget otherReasonTextFieldBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    Widget otherReasonTextField,
  ) {
    return otherReasonTextField;
  }

  /// Builds the submit button.
  Widget submitButtonBuilder(
    BuildContext context,
    String entityId,
    int? reportTagId,
    String? reason,
    LMChatButton submitButton,
  ) {
    return submitButton;
  }

  /// Build MemberReported Dialog
  Widget memberReportedDialogBuilder(
    BuildContext context,
    LMChatDialog defMemberReportedDialog,
  ) {
    return defMemberReportedDialog;
  }
}
