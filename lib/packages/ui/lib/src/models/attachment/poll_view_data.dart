class LMChatPollViewData {
  final int? id;
  final String text;
  final bool? isSelected;
  final int? percentage;
  final int? noVotes;
  final int? memberId;
  final int? conversationId;
  final int? chatroomId;
  final int? count;

  LMChatPollViewData._({
    required this.id,
    required this.text,
    required this.isSelected,
    required this.percentage,
    required this.noVotes,
    required this.memberId,
    required this.conversationId,
    required this.chatroomId,
    required this.count,
  });
}

class LMChatPollViewDataBuilder {
  int? _id;
  String? _text;
  bool? _isSelected;
  int? _percentage;
  int? _noVotes;
  int? _memberId;
  int? _conversationId;
  int? _chatroomId;
  int? _count;

  void id(int? id) {
    _id = id;
  }

  void text(String text) {
    _text = text;
  }

  void isSelected(bool? isSelected) {
    _isSelected = isSelected;
  }

  void percentage(int? percentage) {
    _percentage = percentage;
  }

  void noVotes(int? noVotes) {
    _noVotes = noVotes;
  }

  void memberId(int? memberId) {
    _memberId = memberId;
  }

  void conversationId(int? conversationId) {
    _conversationId = conversationId;
  }

  void chatroomId(int? chatroomId) {
    _chatroomId = chatroomId;
  }

  void count(int? count) {
    _count = count;
  }

  LMChatPollViewData build() {
    if (_text == null) {
      throw StateError("text is required");
    }
    return LMChatPollViewData._(
      id: _id,
      text: _text!,
      isSelected: _isSelected,
      percentage: _percentage,
      noVotes: _noVotes,
      memberId: _memberId,
      conversationId: _conversationId,
      chatroomId: _chatroomId,
      count: _count,
    );
  }
}
