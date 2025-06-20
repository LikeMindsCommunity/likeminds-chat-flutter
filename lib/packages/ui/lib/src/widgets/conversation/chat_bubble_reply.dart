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

  /// onTap function for the reply item
  final VoidCallback? onTap;

  /// {@macro lm_chat_bubble_reply}
  const LMChatBubbleReply({
    super.key,
    required this.replyToConversation,
    this.title,
    this.subtitle,
    this.media,
    this.chatBubbleReplyStyle,
    this.onTap,
  });

  LMChatBubbleReply copyWith({
    LMChatConversationViewData? replyToConversation,
    Widget? title,
    Widget? subtitle,
    Widget? media,
    LMChatBubbleReplyStyle? chatBubbleReplyStyle,
    VoidCallback? onTap,
  }) {
    return LMChatBubbleReply(
      replyToConversation: replyToConversation ?? this.replyToConversation,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      media: media ?? this.media,
      chatBubbleReplyStyle: chatBubbleReplyStyle ?? this.chatBubbleReplyStyle,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = LMChatTheme.theme;
    final inStyle = chatBubbleReplyStyle ?? theme.replyStyle;
    final width = MediaQuery.sizeOf(context).width;
     final relativeWidth = width < 500 ? width * 0.55 : width * 0.35;
    final height = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color:
              inStyle.backgroundColor ?? theme.disabledColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(inStyle.borderRadius ?? 8),
        ),
        constraints: BoxConstraints(
          minWidth: width * 0.2,
          maxWidth: width * 0.64,
        ),
        margin: inStyle.margin ?? const EdgeInsets.symmetric(vertical: 4),
        padding: inStyle.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: height * 0.06,
              width: width * 0.01,
              decoration: BoxDecoration(
                color: inStyle.highlightColor ?? theme.primaryColor,
              ),
            ),
            kHorizontalPaddingMedium,
            SizedBox(
              width: relativeWidth * 0.82,
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
                            textStyle:
                                replyToConversation.deletedByUserId != null
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
                      : subtitle ??
                          LMChatText(
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

  LMChatBubbleReplyStyle copyWith({
    Color? backgroundColor,
    Color? highlightColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    LMChatTextStyle? titleStyle,
    LMChatTextStyle? subtitleStyle,
    LMChatImageStyle? mediaStyle,
  }) {
    return LMChatBubbleReplyStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      highlightColor: highlightColor ?? this.highlightColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      mediaStyle: mediaStyle ?? this.mediaStyle,
    );
  }
}
