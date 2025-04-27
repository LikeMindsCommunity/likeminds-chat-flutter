part of 'chat_bubble.dart';

// This file is part of the 'chat_bubble.dart' file.
// It defines the `LMChatStateBubble` widget and its associated style class `LMChatStateBubbleStyle`.
class LMChatStateBubble extends StatelessWidget {
  /// The message to be displayed in the bubble.
  final String message;

  /// this is for clickable text
  final String? clickableText;

  /// The function to be called when the clickable text is clicked.
  final VoidCallback? onClickableTextClicked;

  /// The style of the bubble.
  final LMChatStateBubbleStyle? style;

  /// The constructor for the [LMChatStateBubble] widget.
  /// It takes a [message], an optional [clickableText], an optional
  /// [onClickableTextClicked] function, and an optional [style].
  /// The [message] is required and cannot be null.
  const LMChatStateBubble({
    super.key,
    this.style,
    required this.message,
    this.clickableText,
    this.onClickableTextClicked,
  });

  /// CopyWith function to get a new object of [LMChatStateBubble]
  /// with specific single values passed
  LMChatStateBubble copyWith({
    LMChatStateBubbleStyle? style,
    String? message,
  }) {
    return LMChatStateBubble(
      style: style ?? this.style,
      message: message ?? this.message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final inStyle = style ?? LMChatTheme.theme.stateBubbleStyle;
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(maxWidth: 70.w),
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: inStyle.boxDecoration ??
                  BoxDecoration(
                    color: inStyle.backgroundColor ??
                        LMChatTheme.theme.container.withOpacity(0.5),
                    borderRadius:
                        BorderRadius.circular(inStyle.borderRadius ?? 18),
                    border: inStyle.border,
                  ),
              alignment: inStyle.alignment ?? Alignment.center,
              child: Wrap(
                children: [
                  LMChatText(
                    message,
                    style: inStyle.messageStyle ??
                        LMChatTextStyle(
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: LMChatTheme.theme.onContainer,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                  ),
                  clickableText != null
                      ? LMChatText(
                          clickableText!,
                          onTap: onClickableTextClicked,
                          style: inStyle.messageStyle ??
                              LMChatTextStyle(
                                padding: const EdgeInsets.only(left: 4),
                                textAlign: TextAlign.center,
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: LMChatTheme.theme.onContainer,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LMChatStateBubbleStyle {
  final Color? backgroundColor;
  final BoxDecoration? boxDecoration;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? shadow;
  final LMChatTextStyle? messageStyle;
  final AlignmentGeometry? alignment;

  LMChatStateBubbleStyle({
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.boxDecoration,
    this.messageStyle,
    this.shadow,
    this.alignment,
  });

  LMChatStateBubbleStyle copyWith({
    Color? backgroundColor,
    BoxDecoration? boxDecoration,
    double? borderRadius,
    Border? border,
    List<BoxShadow>? shadow,
    LMChatTextStyle? messageStyle,
    AlignmentGeometry? alignment,
  }) {
    return LMChatStateBubbleStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      boxDecoration: boxDecoration ?? this.boxDecoration,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      messageStyle: messageStyle ?? this.messageStyle,
      shadow: shadow ?? this.shadow,
      alignment: alignment ?? this.alignment,
    );
  }

  factory LMChatStateBubbleStyle.basic(Color? onContainer) {
    return LMChatStateBubbleStyle(
      messageStyle: LMChatTextStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontSize: 12,
          color: onContainer,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
