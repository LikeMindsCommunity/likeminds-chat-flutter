import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/enums.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatMediaErrorWidget extends StatelessWidget {
  final bool isPP;
  final LMChatMediaErrorStyle? style;

  const LMChatMediaErrorWidget({Key? key, this.isPP = false, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isPP
          ? (style?.primaryColor ?? LMChatTheme.theme.primaryColor)
          : (style?.backgroundColor ?? LMChatDefaultTheme.whiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.error_outline,
            style: LMChatIconStyle(
              size: 10,
              color: isPP
                  ? (style?.iconColor ?? LMChatDefaultTheme.whiteColor)
                  : (style?.textColor ?? LMChatDefaultTheme.blackColor),
            ),
          ),
          isPP ? const SizedBox() : const SizedBox(height: 12),
          isPP
              ? const SizedBox()
              : LMChatText(
                  "An error occurred fetching media",
                  style: LMChatTextStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontSize: 8,
                      color: isPP
                          ? (style?.textColor ?? LMChatDefaultTheme.whiteColor)
                          : (style?.textColor ?? LMChatDefaultTheme.blackColor),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class LMChatMediaErrorStyle {
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  LMChatMediaErrorStyle({
    this.primaryColor,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });
}
