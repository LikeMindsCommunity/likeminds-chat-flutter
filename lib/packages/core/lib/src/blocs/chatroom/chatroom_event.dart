part of 'chatroom_bloc.dart';

@immutable
abstract class LMChatroomEvent extends Equatable {}

class LMChatInitChatroomEvent extends LMChatroomEvent {
  final GetChatroomRequest chatroomRequest;

  LMChatInitChatroomEvent(this.chatroomRequest);

  @override
  List<Object> get props => [
        chatroomRequest,
      ];
}

class LMChatroomDetailsEvent extends LMChatroomEvent {
  @override
  List<Object> get props => [];
}

class LMChatRefreshChatroomEvent extends LMChatroomEvent {
  @override
  List<Object> get props => [];
}
