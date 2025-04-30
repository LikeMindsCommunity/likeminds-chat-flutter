import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_approve_reject_style.dart';

/// A Flutter StatefulWidget that displays Approve/Reject options, typically for DM requests.
class LMChatApproveRejectView extends StatefulWidget {
  /// Creates an instance of [LMChatApproveRejectView].
  ///
  /// Requires callbacks for when the approve and reject buttons are clicked.
  const LMChatApproveRejectView({
    super.key,
    required this.onApproveButtonClicked,
    required this.onRejectButtonClicked,
    this.approveRejectTextBuilder,
    this.approveButtonBuilder,
    this.rejectButtonBuilder,
    this.style,
  });

  /// Callback function triggered when the "Approve" button is tapped.
  final VoidCallback onApproveButtonClicked;

  /// Callback function triggered when the "Reject" button is tapped.
  final VoidCallback onRejectButtonClicked;

  /// Builder function to customize the text displayed in the approve/reject view.
  final LMChatTextBuilder? approveRejectTextBuilder;

  /// Builder function to customize the "Approve" button widget.
  final LMChatButtonBuilder? approveButtonBuilder;

  /// Builder function to customize the "Reject" button widget.
  final LMChatButtonBuilder? rejectButtonBuilder;

  /// Style configuration for the approve/reject view.
  final LMChatApproveRejectStyle? style;

  /// Creates the mutable state for this widget at a given location in the tree.
  /// Creates a copy of this widget with the ability to override certain properties.
  LMChatApproveRejectView copyWith({
    VoidCallback? onApproveButtonClicked,
    VoidCallback? onRejectButtonClicked,
    LMChatTextBuilder? approveRejectTextBuilder,
    LMChatButtonBuilder? approveButtonBuilder,
    LMChatButtonBuilder? rejectButtonBuilder,
    LMChatApproveRejectStyle? style,
  }) {
    return LMChatApproveRejectView(
      onApproveButtonClicked:
          onApproveButtonClicked ?? this.onApproveButtonClicked,
      onRejectButtonClicked:
          onRejectButtonClicked ?? this.onRejectButtonClicked,
      approveButtonBuilder: approveButtonBuilder ?? this.approveButtonBuilder,
      rejectButtonBuilder: rejectButtonBuilder ?? this.rejectButtonBuilder,
      approveRejectTextBuilder:
          approveRejectTextBuilder ?? this.approveRejectTextBuilder,
      style: style ?? this.style,
    );
  }

  @override
  State<LMChatApproveRejectView> createState() =>
      _LMChatApproveRejectViewState();
}

/// The state associated with [LMChatApproveRejectView].
class _LMChatApproveRejectViewState extends State<LMChatApproveRejectView> {
  final LMChatThemeData _themeData = LMChatTheme.instance.themeData;
  late final LMChatApproveRejectStyle _style;

  @override
  void initState() {
    _style = widget.style ?? LMChatApproveRejectStyle.basic();
    super.initState();
  }

  /// Builds the user interface for the approve/reject view.
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _style.alignment,
      padding: _style.padding,
      decoration: _style.decoration,
      foregroundDecoration: _style.foregroundDecoration,
      width: _style.width,
      height: _style.height,
      constraints: _style.constraints,
      margin: _style.margin,
      transform: _style.transform,
      transformAlignment: _style.transformAlignment,
      clipBehavior: _style.clipBehavior,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Uses the screen builder to potentially customize the text, falls back to default.
          widget.approveRejectTextBuilder
                  ?.call(context, _defApproveRejectText(context)) ??
              _defApproveRejectText(context),
          // Uses the screen builder to potentially customize the approve button, falls back to default.
          widget.approveButtonBuilder?.call(_defaultApproveButton(context)) ??
              _defaultApproveButton(context),
          // Uses the screen builder to potentially customize the reject button, falls back to default.
          widget.rejectButtonBuilder?.call(_defaultRejectButton(context)) ??
              _defaultRejectButton(context),
        ],
      ),
    );
  }

  /// Builds the default descriptive text widget.
  LMChatText _defApproveRejectText(BuildContext context) => LMChatText(
        'The sender has sent you a direct messaging request. Approve or respond with a message to get connected. Rejecting this request will not notify the sender.',
        style: LMChatTextStyle(
          textStyle: TextStyle(color: _themeData.inActiveColor),
        ),
      );

  /// Builds the default "Approve" button widget.
  LMChatButton _defaultApproveButton(BuildContext context) {
    return LMChatButton(
      onTap: widget.onApproveButtonClicked,
      style: LMChatButtonStyle(
        margin: const EdgeInsets.only(bottom: 20, top: 26),
        spacing: 27,
        icon: LMChatIcon(
          type: LMChatIconType.svg,
          assetPath: kApproveIcon,
          style: LMChatIconStyle(
            color: _themeData.primaryColor,
          ),
        ),
        backgroundColor: _themeData.container,
      ),
      text: LMChatText('Approve',
          style: LMChatTextStyle(
            textStyle: TextStyle(color: _themeData.primaryColor),
          )),
    );
  }

  /// Builds the default "Reject" button widget.
  LMChatButton _defaultRejectButton(BuildContext context) {
    return LMChatButton(
      onTap: widget.onRejectButtonClicked,
      style: LMChatButtonStyle(
        spacing: 27,
        icon: LMChatIcon(
          type: LMChatIconType.svg,
          assetPath: kRejectIcon,
          style: LMChatIconStyle(
            color: _themeData.primaryColor,
          ),
        ),
        backgroundColor: _themeData.container,
      ),
      text: LMChatText('Reject',
          style: LMChatTextStyle(
            textStyle: TextStyle(color: _themeData.primaryColor),
          )),
    );
  }
}
