part of 'chat_bubble.dart';

class LMChatBubbleReactions extends StatefulWidget {
  final LMChatConversationViewData conversation;
  final LMChatUserViewData currentUser;
  final Map<int, LMChatUserViewData> userMeta;
  final List<LMChatReactionViewData>? reactions;
  final bool? isSent;
  final Function(String reaction)? onRemoveReaction;
  final LMChatBubbleReactionsStyle? style;

  const LMChatBubbleReactions({
    super.key,
    this.isSent,
    this.onRemoveReaction,
    this.reactions,
    required this.userMeta,
    required this.conversation,
    required this.currentUser,
    this.style,
  });

  @override
  State<LMChatBubbleReactions> createState() => _LMChatBubbleReactionsState();
}

class _LMChatBubbleReactionsState extends State<LMChatBubbleReactions> {
  LMChatConversationViewData? conversation;
  List<LMChatReactionViewData> reactions = [];
  Map<String, List<LMChatReactionViewData>> mappedReactions = {};

  @override
  void initState() {
    super.initState();
    conversation = widget.conversation;
    reactions = widget.reactions ?? [];
    mappedReactions = convertListToMapReaction(reactions);
  }

  @override
  void didUpdateWidget(covariant LMChatBubbleReactions oldWidget) {
    conversation = widget.conversation;
    reactions = widget.reactions ?? [];
    mappedReactions = convertListToMapReaction(reactions);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = mappedReactions.keys.toList();
    LMChatBubbleReactionsStyle effectiveStyle =
        widget.style ?? LMChatTheme.theme.bubbleReactionsStyle;

    return ((conversation!.hasReactions ?? false) &&
            (widget.reactions != null && widget.reactions!.isNotEmpty) &&
            conversation!.deletedByUserId == null)
        ? Container(
            padding: effectiveStyle.padding ?? EdgeInsets.zero,
            margin: effectiveStyle.margin ?? EdgeInsets.zero,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  elevation: 5,
                  useSafeArea: true,
                  builder: (context) => LMChatReactionBottomSheet(
                    mappedReactions: mappedReactions,
                    userMeta: widget.userMeta,
                    currentUser: widget.currentUser,
                    conversation: conversation!,
                    onRemoveReaction: widget.onRemoveReaction,
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (keys.length >= 2)
                    Container(
                      padding:
                          effectiveStyle.containerPadding ?? EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: effectiveStyle.containerColor ??
                            LMChatTheme.theme.container,
                        borderRadius: BorderRadius.circular(
                          effectiveStyle.containerBorderRadius ?? 18.0,
                        ),
                      ),
                      child: LMChatText(
                        '${keys[1]}${mappedReactions[keys[1]]!.length}',
                        style: LMChatTextStyle(
                          textStyle: effectiveStyle.reactionTextStyle ??
                              const TextStyle(),
                        ),
                      ),
                    ),
                  if (keys.length >= 3)
                    Container(
                      margin: const EdgeInsets.only(left: 4.0),
                      padding: effectiveStyle.containerPadding,
                      decoration: BoxDecoration(
                        color: effectiveStyle.containerColor ??
                            LMChatTheme.theme.container,
                        borderRadius: BorderRadius.circular(
                          effectiveStyle.containerBorderRadius ?? 18.0,
                        ),
                      ),
                      child: LMChatText(
                        '${keys[2]}${mappedReactions[keys[2]]!.length}',
                        style: LMChatTextStyle(
                          textStyle: effectiveStyle.reactionTextStyle,
                        ),
                      ),
                    ),
                  kHorizontalPaddingSmall,
                  if (keys.length > 3)
                    Container(
                      padding: effectiveStyle.containerPadding,
                      decoration: BoxDecoration(
                        color: effectiveStyle.containerColor ??
                            LMChatTheme.theme.container,
                        borderRadius: BorderRadius.circular(
                          effectiveStyle.containerBorderRadius ?? 18.0,
                        ),
                      ),
                      child: Text(
                        '...',
                        style: effectiveStyle.reactionTextStyle,
                      ),
                    ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Map<String, List<LMChatReactionViewData>> convertListToMapReaction(
      List<LMChatReactionViewData> reaction) {
    Map<String, List<LMChatReactionViewData>> mappedReactions = {};
    mappedReactions = {'All': reaction};
    for (var element in reaction) {
      if (mappedReactions.containsKey(element.reaction)) {
        mappedReactions[element.reaction]?.add(element);
      } else {
        mappedReactions[element.reaction] = [element];
      }
    }
    return mappedReactions;
  }
}

///{@template lm_chat_bubble_reactions_style}
/// A class that defines the style for the chat bubble reactions.
///
/// This class contains properties that determine the appearance of the
/// reaction bubbles in the chat interface, including padding, margin,
/// container color, border radius, and text style for the reactions.
/// {@endtemplate}
class LMChatBubbleReactionsStyle {
  /// The padding applied to the entire reaction bubble.
  final EdgeInsets? padding;

  /// The margin applied around the reaction bubble.
  final EdgeInsets? margin;

  /// The padding applied inside the container of the reaction bubble.
  final EdgeInsets? containerPadding;

  /// The background color of the reaction bubble container.
  final Color? containerColor;

  /// The border radius of the reaction bubble container.
  final double? containerBorderRadius;

  /// The text style applied to the reaction text within the bubble.
  final TextStyle? reactionTextStyle;

  /// {@macro lm_chat_bubble_reactions_style}
  const LMChatBubbleReactionsStyle({
    this.padding,
    this.margin,
    this.containerPadding,
    this.containerColor,
    this.containerBorderRadius,
    this.reactionTextStyle,
  });

  factory LMChatBubbleReactionsStyle.basic() {
    return const LMChatBubbleReactionsStyle(
      padding: EdgeInsets.only(top: 4),
      margin: EdgeInsets.only(left: 8),
      containerPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      containerBorderRadius: 18.0,
      reactionTextStyle: TextStyle(),
    );
  }

  LMChatBubbleReactionsStyle copyWith({
    EdgeInsets? padding,
    EdgeInsets? margin,
    EdgeInsets? containerPadding,
    Color? containerColor,
    double? containerBorderRadius,
    TextStyle? reactionTextStyle,
  }) {
    return LMChatBubbleReactionsStyle(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      containerPadding: containerPadding ?? this.containerPadding,
      containerColor: containerColor ?? this.containerColor,
      containerBorderRadius:
          containerBorderRadius ?? this.containerBorderRadius,
      reactionTextStyle: reactionTextStyle ?? this.reactionTextStyle,
    );
  }
}
