import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';

/// A Flutter StatefulWidget that displays Approve/Reject options, typically for DM requests.
class LMChatApproveRejectView extends StatefulWidget {
  /// Creates an instance of [LMChatApproveRejectView].
  ///
  /// Requires callbacks for when the approve and reject buttons are clicked.
  const LMChatApproveRejectView({
    super.key,
    required this.onApproveButtonClicked,
    required this.onRejectButtonClicked,
  });

  /// Callback function triggered when the "Approve" button is tapped.
  final VoidCallback onApproveButtonClicked;

  /// Callback function triggered when the "Reject" button is tapped.
  final VoidCallback onRejectButtonClicked;

  /// Creates the mutable state for this widget at a given location in the tree.

  @override
  State<LMChatApproveRejectView> createState() =>
      _LMChatApproveRejectViewState();
}

/// The state associated with [LMChatApproveRejectView].
class _LMChatApproveRejectViewState extends State<LMChatApproveRejectView> {
  final _screenBuilder = LMChatCore.config.chatRoomConfig.builder;
  final LMChatThemeData _themeData = LMChatTheme.instance.themeData;

  /// Builds the user interface for the approve/reject view.
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _themeData.container,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Uses the screen builder to potentially customize the text, falls back to default.
          _screenBuilder.dmApproveRejectText(
              context, _defApproveRejectText(context)),
          // Uses the screen builder to potentially customize the approve button, falls back to default.
          _screenBuilder.dmApproveButton(
              context, _defaultApproveButton(context)),
          // Uses the screen builder to potentially customize the reject button, falls back to default.
          _screenBuilder.dmRejectButton(context, _defaultRejectButton(context)),
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
          backgroundColor: _themeData.container,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          )),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LMChatIcon(
            type: LMChatIconType.svg,
            assetPath: kApproveIcon,
            style: LMChatIconStyle(
              color: _themeData.primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          LMChatText('Approve',
              style: LMChatTextStyle(
                textStyle: TextStyle(color: _themeData.primaryColor),
              )),
        ],
      ),
    );
  }

  /// Builds the default "Reject" button widget.
  LMChatButton _defaultRejectButton(BuildContext context) {
    return LMChatButton(
      onTap: widget.onRejectButtonClicked,
      style: LMChatButtonStyle(
          backgroundColor: _themeData.container,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          )),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LMChatIcon(
            type: LMChatIconType.svg,
            assetPath: kRejectIcon,
            style: LMChatIconStyle(
              color: _themeData.primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          LMChatText('Reject',
              style: LMChatTextStyle(
                textStyle: TextStyle(color: _themeData.primaryColor),
              )),
        ],
      ),
    );
  }
}
