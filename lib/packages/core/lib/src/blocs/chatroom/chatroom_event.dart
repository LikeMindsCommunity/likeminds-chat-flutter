part of 'chatroom_bloc.dart';

@immutable
abstract class LMChatroomEvent extends Equatable {}

class LMChatFetchChatroomEvent extends LMChatroomEvent {
  final int chatroomId;

  LMChatFetchChatroomEvent({required this.chatroomId});

  @override
  List<Object> get props => [
        chatroomId,
      ];
}

class LMChatroomDetailsEvent extends LMChatroomEvent {
  @override
  List<Object> get props => [];
}
