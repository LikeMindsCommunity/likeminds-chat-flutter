/// `LMChatReactionViewData` is a model class that contains the data required to render a reaction in the chat.
/// This class is used to display the reactions in the chat screen.
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

  /// copyWith method is used to create a new instance of `LMChatReactionViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatReactionViewData copyWith({
    int? chatroomId,
    int? conversationId,
    int? reactionId,
    int? userId,
    String? reaction,
  }) {
    return LMChatReactionViewData._(
      chatroomId: chatroomId ?? this.chatroomId,
      conversationId: conversationId ?? this.conversationId,
      reactionId: reactionId ?? this.reactionId,
      userId: userId ?? this.userId,
      reaction: reaction ?? this.reaction,
    );
  }
}

/// `LMChatReactionViewDataBuilder` is a builder class used to create an instance of `LMChatReactionViewData`.
/// This class is used to create an instance of `LMChatReactionViewData` with the provided values.
class LMChatReactionViewDataBuilder {
  int? _chatroomId;
  int? _conversationId;
  int? _reactionId;
  int? _userId;
  String? _reaction;

  void chatroomId(int? chatroomId) {
    _chatroomId = chatroomId;
  }

  void conversationId(int? conversationId) {
    _conversationId = conversationId;
  }

  void reactionId(int? reactionId) {
    _reactionId = reactionId;
  }

  void userId(int? userId) {
    _userId = userId;
  }

  void reaction(String? reaction) {
    _reaction = reaction;
  }

  LMChatReactionViewData build() {
    return LMChatReactionViewData._(
      chatroomId: _chatroomId!,
      conversationId: _conversationId!,
      reactionId: _reactionId!,
      userId: _userId!,
      reaction: _reaction!,
    );
  }
}
