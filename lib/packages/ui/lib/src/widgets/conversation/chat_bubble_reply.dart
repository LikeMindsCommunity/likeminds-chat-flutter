// import 'package:flutter/material.dart';
// import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
// import 'package:likeminds_chat_ui_fl/src/utils/theme.dart';
// import 'package:likeminds_chat_ui_fl/src/utils/utils.dart';
// import 'package:likeminds_chat_ui_fl/src/widgets/common/text/text_view.dart';
part of 'chat_bubble.dart';

class LMChatBubbleReply extends StatelessWidget {
  final LMChatConversationViewData replyToConversation;

  final Widget? title;
  final Widget? subtitle;
  final Widget? media;

  final LMChatBubbleReplyStyle? chatBubbleReplyStyle;

  const LMChatBubbleReply({
    super.key,
    required this.replyToConversation,
    this.title,
    this.subtitle,
    this.media,
    this.chatBubbleReplyStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LMChatTheme.theme;
    final inStyle = chatBubbleReplyStyle ?? theme.replyStyle;

    return Container(
      decoration: BoxDecoration(
        color: inStyle.backgroundColor ?? theme.container,
        borderRadius: BorderRadius.circular(inStyle.borderRadius ?? 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Container(
            height: 4.h,
            width: 1.w,
            decoration: BoxDecoration(
              color: inStyle.highlightColor ?? theme.primaryColor,
            ),
          ),
          kHorizontalPaddingMedium,
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                title ??
                    LMChatText(
                      replyToConversation.member!.name,
                      style: LMChatTextStyle(
                        maxLines: 1,
                        textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                kVerticalPaddingXSmall,
                subtitle ??
                    LMChatText(
                      replyToConversation.answer.isEmpty
                          ? "Media files"
                          : replyToConversation.answer,
                      style: LMChatTextStyle(
                        maxLines: 1,
                        textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: theme.onContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          kHorizontalPaddingMedium,
        ],
      ),
    );
  }
}

class LMChatBubbleReplyStyle {
  final Color? backgroundColor;
  final Color? highlightColor;
  final double? borderRadius;
  final LMChatTextStyle? titleStyle;
  final LMChatTextStyle? subtitleStyle;
  final LMChatImageStyle? mediaStyle;

  const LMChatBubbleReplyStyle({
    this.backgroundColor,
    this.highlightColor,
    this.borderRadius,
    this.titleStyle,
    this.subtitleStyle,
    this.mediaStyle,
  });
}
// class LMReplyItem extends StatelessWidget {
//   const LMReplyItem({
//     super.key,
//     required this.replyToConversation,
//     this.backgroundColor,
//     this.highlightColor,
//     this.title,
//     this.subtitle,
//     this.borderRadius,
//   });

//   /// The conversation to which the reply is made
//   /// This is a required field
//   final Conversation? replyToConversation;

//   /// Color of the reply item background
//   final Color? backgroundColor;

//   /// Color of the reply item highlight bar (on the left)
//   final Color? highlightColor;

//   /// Title widget of the reply item, if not provided, the name of the member
//   /// Preferrably use a [LMTextView] widget, when providing a custom title
//   final Widget? title;

//   /// Subtitle widget of the reply item, if not provided, the text of reply
//   /// Preferrably use a [LMTextView] widget, when providing a custom subtitle
//   final Widget? subtitle;

//   /// Border radius of the reply item
//   final double? borderRadius;

//   @override
//   Widget build(BuildContext context) {
//     return replyToConversation != null
//         : const SizedBox();
//   }
// }
