class LMChatPollOPtionViewData {
  final String? id;
  final String text;
  final bool? isSelected;
  final int? percentage;
  final String? subText;
  final int? noVotes;
  final String? userId;
  final int? conversationId;
  final int? count;

  LMChatPollOPtionViewData({
    required this.id,
    required this.text,
    required this.isSelected,
    required this.percentage,
    required this.subText,
    required this.noVotes,
    required this.userId,
    required this.conversationId,
    required this.count,
  });
}
