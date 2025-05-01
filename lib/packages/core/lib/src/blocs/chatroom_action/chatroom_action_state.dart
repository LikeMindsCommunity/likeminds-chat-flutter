part of 'chatroom_action_bloc.dart';

@immutable
abstract class LMChatroomActionState extends Equatable {}

class LMChatChatroomActionInitial extends LMChatroomActionState {
  @override
  List<Object?> get props => [];
}

class LMChatChatroomActionLoading extends LMChatroomActionState {
  @override
  List<Object?> get props => [];
}

class LMChatChatroomTopicSet extends LMChatroomActionState {
  final Conversation topic;
  LMChatChatroomTopicSet(this.topic);
  @override
  List<Object?> get props => [topic];
}

class LMChatChatroomTopicError extends LMChatroomActionState {
  final String errorMessage;
  LMChatChatroomTopicError({
    required this.errorMessage,
  });
  @override
  List<Object?> get props => [errorMessage];
}

class LMChatShowEmojiKeyboardState extends LMChatroomActionState {
  final int conversationId;

  LMChatShowEmojiKeyboardState({required this.conversationId});
  @override
  List<Object?> get props => [conversationId];
}

class LMChatHideEmojiKeyboardState extends LMChatroomActionState {
  LMChatHideEmojiKeyboardState();
  @override
  List<Object?> get props => [];
}

// chatroom action update state
class LMChatroomActionUpdateState extends LMChatroomActionState {
  final ChatRoom chatroom;
  final List<ChatroomAction> actions;

  LMChatroomActionUpdateState({
    required this.chatroom,
    required this.actions,
  });

  @override
  List<Object> get props => [chatroom, actions];
}

/// State to represent an error during chatroom action updates
class LMChatroomActionUpdateErrorState extends LMChatroomActionState {
  /// Error message describing the issue
  final String errorMessage;

  /// Constructor to initialize the error message
  LMChatroomActionUpdateErrorState({
    required this.errorMessage,
  });

  // Equatable props to compare instances
  @override
  List<Object?> get props => [errorMessage];
}
