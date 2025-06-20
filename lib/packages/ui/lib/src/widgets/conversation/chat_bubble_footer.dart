part of 'chat_bubble.dart';

/// A widget that represents the footer of a chat bubble.
class LMChatBubbleFooter extends StatelessWidget {
  /// The conversation data associated with the chat bubble.
  final LMChatConversationViewData conversation;

  /// Optional width for the footer.
  final double? textWidth;

  /// Optional timestamp text widget.
  final LMChatText? timeStamp;

  /// Optional pending timer icon.
  final LMChatIcon? pendingTimer;

  /// Optional style for the footer.
  final LMChatBubbleFooterStyle? style;

  /// Optional timestamp text widget.
  final Widget? voiceDuration;

  late double _screenWidth;

  /// Creates an instance of [LMChatBubbleFooter].
  LMChatBubbleFooter({
    super.key,
    required this.conversation, // Required conversation data.
    this.textWidth, // Accept the width.
    this.pendingTimer,
    this.timeStamp,
    this.style,
    this.voiceDuration,
  });

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.sizeOf(context).width;

    // Builds the footer widget.
    return SizedBox(
      width: calculateFooterWidth(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (voiceDuration != null) const SizedBox(width: 60),
          voiceDuration ?? const SizedBox.shrink(),
          if (voiceDuration != null) const Spacer(),
          if (conversation.isEdited ?? false) ...[
            LMChatText(
              'Edited',
              style: LMChatTextStyle(
                textStyle: TextStyle(
                  fontSize: 12,
                  color: LMChatTheme.theme.onContainer.withOpacity(0.6),
                ),
              ),
            ),
            LMChatText(
              ' • ',
              style: LMChatTextStyle(
                textStyle: TextStyle(
                  fontSize: 12,
                  color: LMChatTheme.theme.onContainer.withOpacity(0.6),
                ),
              ),
            ),
          ],
          conversation.createdAt.isNotEmpty
              ? LMChatText(
                  conversation.createdAt,
                  style: LMChatTextStyle(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: LMChatTheme.theme.onContainer.withOpacity(0.6),
                    ),
                  ),
                )
              : LMChatIcon(
                  type: LMChatIconType.icon,
                  icon: Icons.timer_outlined,
                  style: LMChatIconStyle(
                    size: 12,
                    color: LMChatTheme.theme.onContainer.withOpacity(0.6),
                  ),
                ),
          // Use the width to push the footer
        ],
      ),
    );
  }

  /// Calculates the width of the footer based on its content.
  double calculateFooterWidth() {
    // if the conversation is of poll type, return the max width.
    final _relativeWidth = _screenWidth < 500 ? _screenWidth * 0.55 : _screenWidth * 0.35;
    if (conversation.state == 10) {
      return _relativeWidth * 0.75;
    }
    if (conversation.attachmentCount == 1 || conversation.replyConversationObject != null) {
      return _relativeWidth * 0.75;
    }
    if ((conversation.attachmentCount??0) > 1) {
      return _relativeWidth * 0.80;
    }
    if (conversation.ogTags != null) {
      return _relativeWidth;
    }
    double? timestamp, edited, result = 0;
    // Measure the footer text width
    final footerPainter = TextPainter(
      text: TextSpan(
        text: conversation.createdAt, // Use the footer content.
        style: const TextStyle(fontSize: 13), // Use the appropriate style.
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    footerPainter.layout();
    timestamp = footerPainter.width;

    if (conversation.isEdited ?? false) {
      final editedTextPainter = TextPainter(
        text: const TextSpan(
          text: 'Edited  • ', // Use the appropriate text for edited status.
          style: TextStyle(fontSize: 12), // Use the appropriate style.
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      );
      editedTextPainter.layout();
      edited = editedTextPainter.width + 2;
    }

    result = timestamp + (edited ?? 0);
    return (textWidth ?? 0) > result ? textWidth ?? 0 : result;
  }

  /// Creates a copy of the current [LMChatBubbleFooter] with optional new values.
  LMChatBubbleFooter copyWith({
    LMChatConversationViewData? conversation,
    LMChatText? timeStamp,
    LMChatIcon? pendingTimer,
    LMChatBubbleFooterStyle? style,
    double? textWidth,
    Widget? voiceDuration,
  }) {
    return LMChatBubbleFooter(
      conversation: conversation ?? this.conversation,
      timeStamp: timeStamp ?? this.timeStamp,
      pendingTimer: pendingTimer ?? this.pendingTimer,
      style: style ?? this.style,
      textWidth: textWidth ?? this.textWidth,
      voiceDuration: voiceDuration ?? this.voiceDuration,
    );
  }
}

/// A style class for customizing the appearance of the chat bubble footer.
class LMChatBubbleFooterStyle {
  /// Style for the timestamp text.
  final LMChatTextStyle? timeStampStyle;

  /// Style for the pending icon.
  final LMChatIconStyle? pendingIconStyle;

  /// Alignment of the main axis.
  final MainAxisAlignment? mainAxisAlignment;

  /// Alignment of the cross axis.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Creates an instance of [LMChatBubbleFooterStyle].
  LMChatBubbleFooterStyle({
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.pendingIconStyle,
    this.timeStampStyle,
  });

  /// Creates a copy of the current [LMChatBubbleFooterStyle] with optional new values.
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

  /// Creates a basic instance of [LMChatBubbleFooterStyle].
  factory LMChatBubbleFooterStyle.basic() {
    return LMChatBubbleFooterStyle();
  }
}
