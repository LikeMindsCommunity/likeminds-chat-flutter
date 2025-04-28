import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';

class LMChatApproveRejectView extends StatefulWidget {
  const LMChatApproveRejectView({
    super.key,
    required this.onApproveButtonClicked,
    required this.onRejectButtonClicked,
  });

  final VoidCallback onApproveButtonClicked;
  final VoidCallback onRejectButtonClicked;

  @override
  State<LMChatApproveRejectView> createState() =>
      _LMChatApproveRejectViewState();
}

class _LMChatApproveRejectViewState extends State<LMChatApproveRejectView> {
  @override
  final _screenBuilder = LMChatCore.config.chatRoomConfig.builder;
  final LMChatThemeData _themeData = LMChatTheme.instance.themeData;
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
          _screenBuilder.dmApproveRejectText(
              context, _defApproveRejectText(context)),
          _screenBuilder.dmApproveButton(
              context, _defaultApproveButton(context)),
          _screenBuilder.dmRejectButton(context, _defaultRejectButton(context)),
        ],
      ),
    );
  }

  LMChatText _defApproveRejectText(BuildContext context) => LMChatText(
        'The sender has sent you a direct messaging request. Approve or respond with a message to get connected. Rejecting this request will not notify the sender.',
        style: LMChatTextStyle(
          // padding: const EdgeInsets.all(10),
          textStyle: TextStyle(color: _themeData.inActiveColor),
        ),
      );

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
