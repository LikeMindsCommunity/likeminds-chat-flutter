class LMChatReactionViewData {
  int? chatroomId;
  int conversationId;
  int? reactionId;
  int userId;
  String reaction;

  LMChatReactionViewData._({
    required this.chatroomId,
    required this.conversationId,
    required this.reactionId,
    required this.userId,
    required this.reaction,
  });
}
