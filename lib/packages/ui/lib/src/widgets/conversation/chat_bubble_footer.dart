part of 'chat_bubble.dart';

class LMChatBubbleFooter extends StatelessWidget {
  final LMChatConversationViewData conversation;

  final LMChatText? timeStamp;
  final LMChatIcon? pendingTimer;

  final LMChatBubbleFooterStyle? style;

  const LMChatBubbleFooter({
    super.key,
    required this.conversation,
    this.pendingTimer,
    this.timeStamp,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.centerRight,
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (conversation.isEdited ?? false)
            LMChatText(
              'Edited',
              style: LMChatTextStyle(
                textStyle: TextStyle(
                  fontSize: 10,
                  color: LMChatTheme.theme.onContainer.withOpacity(0.6),
                ),
              ),
            ),
          if (conversation.isEdited ?? false)
            LMChatText(
              ' • ',
              style: LMChatTextStyle(
                textStyle: TextStyle(
                  fontSize: 10,
                  color: LMChatTheme.theme.onContainer.withOpacity(0.6),
                ),
              ),
            ),
          conversation.createdAt.isNotEmpty
              ? LMChatText(
                  conversation.createdAt,
                  style: LMChatTextStyle(
                    textStyle: TextStyle(
                      fontSize: 10,
                      color: LMChatTheme.theme.onContainer.withOpacity(0.6),
                    ),
                  ),
                )
              : LMChatIcon(
                  type: LMChatIconType.icon,
                  icon: Icons.timer_outlined,
                  style: LMChatIconStyle(
                    size: 10,
                    color: LMChatTheme.theme.onContainer.withOpacity(0.6),
                  ),
                ),
        ],
      ),
    );
  }

  LMChatBubbleFooter copyWith({
    LMChatConversationViewData? conversation,
    LMChatText? timeStamp,
    LMChatIcon? pendingTimer,
    LMChatBubbleFooterStyle? style,
  }) {
    return LMChatBubbleFooter(
      conversation: conversation ?? this.conversation,
      timeStamp: timeStamp ?? this.timeStamp,
      pendingTimer: pendingTimer ?? this.pendingTimer,
      style: style ?? this.style,
    );
  }

  @override
  void debugAssertDoesMeetConstraints() {
    // TODO: implement debugAssertDoesMeetConstraints
  }

  @override
  // TODO: implement paintBounds
  Rect get paintBounds => throw UnimplementedError();

  @override
  void performLayout() {
    // TODO: implement performLayout
  }

  @override
  void performResize() {
    // TODO: implement performResize
  }

  @override
  // TODO: implement semanticBounds
  Rect get semanticBounds => throw UnimplementedError();
}

class LMChatBubbleFooterStyle {
  final LMChatTextStyle? timeStampStyle;
  final LMChatIconStyle? pendingIconStyle;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  LMChatBubbleFooterStyle({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.pendingIconStyle,
    this.timeStampStyle,
  });

  LMChatBubbleFooterStyle copyWith({
    LMChatTextStyle? timeStampStyle,
    LMChatIconStyle? pendingIconStyle,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
  }) {
    return LMChatBubbleFooterStyle(
      timeStampStyle: timeStampStyle ?? this.timeStampStyle,
      pendingIconStyle: pendingIconStyle ?? this.pendingIconStyle,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
    );
  }

  factory LMChatBubbleFooterStyle.basic() {
    return LMChatBubbleFooterStyle();
  }
}
