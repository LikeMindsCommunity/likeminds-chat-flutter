part of 'chat_bubble.dart';

class LMChatStateBubble extends StatelessWidget {
  final String message;
  final LMChatStateBubbleStyle? style;

  const LMChatStateBubble({
    super.key,
    this.style,
    required this.message,
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
              child: LMChatText(
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

  factory LMChatStateBubbleStyle.basic() {
    return LMChatStateBubbleStyle(
      messageStyle: LMChatTextStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontSize: 12,
          color: LMChatTheme.theme.onContainer,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
