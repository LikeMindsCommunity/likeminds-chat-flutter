part of 'chat_bubble.dart';

class LMChatBubbleHeader extends StatelessWidget {
  final LMChatUserViewData conversationUser;
  final LMChatTextStyle? style;

  const LMChatBubbleHeader({
    super.key,
    this.style,
    required this.conversationUser,
  });

  LMChatBubbleHeader copyWith({
    LMChatTextStyle? style,
  }) {
    return LMChatBubbleHeader(
      conversationUser: conversationUser,
      style: style ?? this.style,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LMChatText(
          conversationUser.name,
          style: style ??
              LMChatTextStyle(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: LMChatTheme.theme.primaryColor,
                ),
              ),
        ),
      ],
    );
  }
}
