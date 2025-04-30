part of 'chatroom_bloc.dart';

@immutable
abstract class LMChatroomEvent extends Equatable {}

class LMChatFetchChatroomEvent extends LMChatroomEvent {
  final int chatroomId;
  final bool? reInitializeConversationList;

  LMChatFetchChatroomEvent(
      {required this.chatroomId, this.reInitializeConversationList});

  @override
  List<Object> get props => [
        chatroomId,
        reInitializeConversationList ?? false,
      ];
}

class LMChatroomDetailsEvent extends LMChatroomEvent {
  @override
  List<Object> get props => [];
}
