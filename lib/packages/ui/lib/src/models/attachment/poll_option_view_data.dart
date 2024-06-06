/// `LMChatPollOPtionViewData` is a model class used to represent the poll option data in the chat.
/// This class is used to display the poll options in the chat screen.
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

  LMChatPollOPtionViewData._({
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

  /// copyWith method is used to create a new instance of `LMChatPollOPtionViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatPollOPtionViewData copyWith({
    String? id,
    String? text,
    bool? isSelected,
    int? percentage,
    String? subText,
    int? noVotes,
    String? userId,
    int? conversationId,
    int? count,
  }) {
    return LMChatPollOPtionViewData._(
      id: id ?? this.id,
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
      percentage: percentage ?? this.percentage,
      subText: subText ?? this.subText,
      noVotes: noVotes ?? this.noVotes,
      userId: userId ?? this.userId,
      conversationId: conversationId ?? this.conversationId,
      count: count ?? this.count,
    );
  }
}

/// `LMChatPollOptionViewDataBuilder` is a builder class used to create an instance of `LMChatPollOPtionViewData`.
/// This class is used to create an instance of `LMChatPollOPtionViewData` with the provided values.
class LMChatPollOptionViewDataBuilder {
  String? _id;
  String? _text;
  bool? _isSelected;
  int? _percentage;
  String? _subText;
  int? _noVotes;
  String? _userId;
  int? _conversationId;
  int? _count;

  void id(String? id) {
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

  void subText(String? subText) {
    _subText = subText;
  }

  void noVotes(int? noVotes) {
    _noVotes = noVotes;
  }

  void userId(String? userId) {
    _userId = userId;
  }

  void conversationId(int? conversationId) {
    _conversationId = conversationId;
  }

  void count(int? count) {
    _count = count;
  }

  /// build method is used to create an instance of `LMChatPollOPtionViewData` with the provided values.
  LMChatPollOPtionViewData build() {
    if (_text == null) throw Exception('text is required');

    return LMChatPollOPtionViewData._(
      id: _id,
      text: _text!,
      isSelected: _isSelected,
      percentage: _percentage,
      subText: _subText,
      noVotes: _noVotes,
      userId: _userId,
      conversationId: _conversationId,
      count: _count,
    );
  }
}
