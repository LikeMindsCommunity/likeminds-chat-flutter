part of 'chatroom_action_bloc.dart';

@immutable
abstract class LMChatroomActionState extends Equatable {}

class ChatroomActionInitial extends LMChatroomActionState {
  @override
  List<Object?> get props => [];
}

class ChatroomActionLoading extends LMChatroomActionState {
  @override
  List<Object?> get props => [];
}

class ChatroomTopicSet extends LMChatroomActionState {
  final Conversation topic;
  ChatroomTopicSet(this.topic);
  @override
  List<Object?> get props => [topic];
}

class ChatroomTopicError extends LMChatroomActionState {
  final String errorMessage;
  ChatroomTopicError({
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
