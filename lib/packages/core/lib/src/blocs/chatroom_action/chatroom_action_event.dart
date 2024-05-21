part of 'chatroom_action_bloc.dart';

@immutable
abstract class ChatroomActionEvent extends Equatable {}

class MarkReadChatroomEvent extends ChatroomActionEvent {
  final int chatroomId;

  MarkReadChatroomEvent({required this.chatroomId});

  @override
  List<Object> get props => [chatroomId];
}

class FollowChatroomEvent extends ChatroomActionEvent {
  final int chatroomId;
  final bool follow;

  FollowChatroomEvent({
    required this.chatroomId,
    required this.follow,
  });

  @override
  List<Object> get props => [chatroomId];
}

class LeaveChatroomEvent extends ChatroomActionEvent {
  final int chatroomId;

  LeaveChatroomEvent({required this.chatroomId});

  @override
  List<Object> get props => [chatroomId];
}

class MuteChatroomEvent extends ChatroomActionEvent {
  final int chatroomId;
  final bool mute;

  MuteChatroomEvent({
    required this.chatroomId,
    required this.mute,
  });

  @override
  List<Object> get props => [chatroomId];
}

class SetChatroomTopicEvent extends ChatroomActionEvent {
  final int chatroomId;
  final int conversationId;
  final Conversation topic;

  SetChatroomTopicEvent({
    required this.chatroomId,
    required this.conversationId,
    required this.topic,
  });

  @override
  List<Object> get props => [chatroomId, conversationId, topic];
}

class ShareChatroomUrlEvent extends ChatroomActionEvent {
  final int chatroomId;
  final String domain;

  ShareChatroomUrlEvent({
    required this.chatroomId,
    required this.domain,
  });

  @override
  List<Object> get props => [chatroomId];
}
