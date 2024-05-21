part of 'chat_bubble.dart';

class LMChatBubbleFooter extends StatelessWidget {
  final Conversation conversation;
  const LMChatBubbleFooter({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LMChatText(
          conversation.createdAt,
          style: const LMChatTextStyle(textStyle: TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}
