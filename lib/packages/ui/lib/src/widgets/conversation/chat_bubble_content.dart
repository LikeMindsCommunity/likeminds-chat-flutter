part of 'chat_bubble.dart';

typedef LMChatBubbleContentBuilder = Widget Function(
    LMChatConversationViewData conversation);

class LMChatBubbleContent extends StatelessWidget {
  const LMChatBubbleContent({
    super.key,
    required this.conversation,
    required this.onTagTap,
    this.style,
    this.textBuilder,
  });

  final LMChatConversationViewData conversation;
  final Function(String tag) onTagTap;
  final LMChatBubbleContentStyle? style;
  final Widget Function(BuildContext context, LMChatExpandableText text)?
      textBuilder;

  @override
  Widget build(BuildContext context) {
    final LMChatBubbleContentStyle inStyle =
        style ?? LMChatTheme.theme.contentStyle;

    return Padding(
      padding: inStyle.padding ?? EdgeInsets.zero,
      child: conversation.answer.isNotEmpty
          ? textBuilder?.call(context, _defText(inStyle)) ?? _defText(inStyle)
          : const SizedBox(),
    );
  }

  LMChatExpandableText _defText(LMChatBubbleContentStyle inStyle) {
    return LMChatExpandableText(
      conversation.answer,
      expandText: "see more",
      enableSelection: inStyle.enableSelection ?? false,
      animation: inStyle.animation ?? true,
      maxLines: inStyle.visibleLines ?? 6,
      mentionStyle: inStyle.tagStyle,
      linkStyle: inStyle.linkStyle ??
          TextStyle(
            color: LMChatTheme.theme.linkColor,
            fontSize: 14,
          ),
      textAlign: TextAlign.left,
      style: inStyle.textStyle ??
          TextStyle(
            fontSize: 14,
            color: LMChatTheme.theme.onContainer,
            fontWeight: FontWeight.w400,
          ),
      linkEllipsis: true,
      onTagTap: onTagTap,
    );
  }

  LMChatBubbleContent copyWith({
    LMChatConversationViewData? conversation,
    Function(String tag)? onTagTap,
    LMChatBubbleContentStyle? style,
    Widget Function(BuildContext context, LMChatExpandableText text)?
        textBuilder,
  }) {
    return LMChatBubbleContent(
      conversation: conversation ?? this.conversation,
      onTagTap: onTagTap ?? this.onTagTap,
      style: style ?? this.style,
      textBuilder: textBuilder ?? this.textBuilder,
    );
  }
}

class LMChatBubbleContentStyle {
  final int? visibleLines;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;
  final TextStyle? tagStyle;
  final bool? animation;
  final TextStyle? expandTextStyle;
  final TextAlign? textAlign;
  final String? expandText;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool? enableSelection;

  const LMChatBubbleContentStyle({
    this.textStyle,
    this.linkStyle,
    this.expandTextStyle,
    this.expandText,
    this.animation,
    this.visibleLines,
    this.textAlign,
    this.padding,
    this.margin,
    this.tagStyle,
    this.enableSelection,
  });

  LMChatBubbleContentStyle copyWith({
    int? visibleLines,
    TextStyle? textStyle,
    TextStyle? linkStyle,
    TextStyle? tagStyle,
    bool? animation,
    TextStyle? expandTextStyle,
    TextAlign? textAlign,
    String? expandText,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool? enableSelection,
  }) {
    return LMChatBubbleContentStyle(
      textStyle: textStyle ?? this.textStyle,
      linkStyle: linkStyle ?? this.linkStyle,
      expandTextStyle: expandTextStyle ?? this.expandTextStyle,
      expandText: expandText ?? this.expandText,
      animation: animation ?? this.animation,
      visibleLines: visibleLines ?? this.visibleLines,
      textAlign: textAlign ?? this.textAlign,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      enableSelection: enableSelection ?? this.enableSelection,
    );
  }

  factory LMChatBubbleContentStyle.basic({Color? onContainer}) =>
      LMChatBubbleContentStyle(
        textStyle: TextStyle(
          color: onContainer ?? LMChatDefaultTheme.onContainer,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
}
