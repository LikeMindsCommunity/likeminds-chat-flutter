part of 'chatroom_bloc.dart';

@immutable
abstract class LMChatroomState extends Equatable {}

class LMChatroomLoadingState extends LMChatroomState {
  @override
  List<Object> get props => [];
}

class LMChatroomLoadedState extends LMChatroomState {
  final ChatRoom chatroom;
  final List<ChatroomAction> actions;
  final int lastConversationId;
  final int participantCount;
  final bool? reInitializeConversationList;

  LMChatroomLoadedState({
    required this.chatroom,
    required this.actions,
    required this.lastConversationId,
    required this.participantCount,
    this.reInitializeConversationList,
  });

  @override
  List<Object> get props => [
        chatroom,
        actions,
        lastConversationId,
        participantCount,
        reInitializeConversationList ?? false,
      ];
}

class LMChatroomErrorState extends LMChatroomState {
  final String message;

  LMChatroomErrorState(this.message);

  @override
  List<Object> get props => [message];
}
