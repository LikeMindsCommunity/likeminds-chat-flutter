part of 'chat_bubble.dart';

class LMChatBubbleHeader extends StatelessWidget {
  final LMChatUserViewData conversationUser;

  const LMChatBubbleHeader({
    super.key,
    required this.conversationUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LMChatText(
          conversationUser.name,
          style: LMChatTextStyle(
            textStyle: TextStyle(
              color: LMChatTheme.theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
