part of 'chat_bubble.dart';

/// {@template lm_chat_bubble_reply}
/// A widget to display a reply to a conversation
/// {@endtemplate}
class LMChatBubbleReply extends StatelessWidget {
  /// The conversation to which the reply is made
  final LMChatConversationViewData replyToConversation;

  /// Title widget of the reply item, if not provided, the name of the member
  final Widget? title;

  /// Subtitle widget of the reply item, if not provided, the text of reply
  final Widget? subtitle;

  /// Media widget of the reply item, if not provided, the media files
  final Widget? media;

  /// Style of the reply item
  final LMChatBubbleReplyStyle? chatBubbleReplyStyle;

  /// {@macro lm_chat_bubble_reply}
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
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: inStyle.backgroundColor ?? theme.disabledColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(inStyle.borderRadius ?? 8),
      ),
      constraints: BoxConstraints(
        minWidth: 20.w,
        maxWidth: 64.w,
      ),
      margin: inStyle.margin ?? const EdgeInsets.symmetric(vertical: 4),
      padding: inStyle.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 6.h,
            width: 1.w,
            decoration: BoxDecoration(
              color: inStyle.highlightColor ?? theme.primaryColor,
            ),
          ),
          kHorizontalPaddingMedium,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title ??
                    LMChatText(
                      replyToConversation.member!.name,
                      style: LMChatTextStyle(
                        maxLines: 1,
                        minLines: 1,
                        textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                kVerticalPaddingXSmall,
                replyToConversation.deletedByUserId != null
                    ? LMChatText(
                        "Deleted message",
                        style: LMChatTextStyle(
                          textStyle: replyToConversation.deletedByUserId != null
                              ? TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: LMChatTheme.theme.disabledColor,
                                )
                              : TextStyle(
                                  fontSize: 14,
                                  color: LMChatTheme.theme.disabledColor,
                                ),
                        ),
                      )
                    : LMChatText(
                        replyToConversation.answer.isEmpty
                            ? "Media files"
                            : LMChatTaggingHelper.convertRouteToTag(
                                replyToConversation.answer,
                                withTilde: false,
                              )!,
                        style: LMChatTextStyle(
                          maxLines: 1,
                          textStyle: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: theme.onContainer,
                            fontSize: 12,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          kHorizontalPaddingMedium,
        ],
      ),
    );
  }
}

/// {@template lm_chat_bubble_reply_style}
/// Style for the reply item
/// {@endtemplate}
class LMChatBubbleReplyStyle {
  /// Background color of the reply item
  final Color? backgroundColor;

  /// Highlight color of the reply item
  final Color? highlightColor;

  /// Border radius of the reply item
  final double? borderRadius;

  /// Padding inside the reply bubble
  final EdgeInsetsGeometry? padding;

  /// Margin outside the reply bubble
  final EdgeInsetsGeometry? margin;

  /// Style of the title widget
  final LMChatTextStyle? titleStyle;

  /// Style of the subtitle widget
  final LMChatTextStyle? subtitleStyle;

  /// Style of the media widget
  final LMChatImageStyle? mediaStyle;

  /// {@macro lm_chat_bubble_reply_style}
  const LMChatBubbleReplyStyle({
    this.backgroundColor,
    this.highlightColor,
    this.borderRadius,
    this.titleStyle,
    this.subtitleStyle,
    this.mediaStyle,
    this.margin,
    this.padding,
  });
}
