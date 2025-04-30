part of 'chatroom_action_bloc.dart';

@immutable
abstract class LMChatroomActionEvent extends Equatable {}

class LMChatMarkReadChatroomEvent extends LMChatroomActionEvent {
  final int chatroomId;

  LMChatMarkReadChatroomEvent({required this.chatroomId});

  @override
  List<Object> get props => [chatroomId];
}

class LMChatFollowChatroomEvent extends LMChatroomActionEvent {
  final int chatroomId;
  final bool follow;

  LMChatFollowChatroomEvent({
    required this.chatroomId,
    required this.follow,
  });

  @override
  List<Object> get props => [chatroomId];
}

class LMChatLeaveChatroomEvent extends LMChatroomActionEvent {
  final int chatroomId;

  LMChatLeaveChatroomEvent({required this.chatroomId});

  @override
  List<Object> get props => [chatroomId];
}

class LMChatMuteChatroomEvent extends LMChatroomActionEvent {
  final int chatroomId;
  final bool mute;

  LMChatMuteChatroomEvent({
    required this.chatroomId,
    required this.mute,
  });

  @override
  List<Object> get props => [chatroomId];
}

class LMChatSetChatroomTopicEvent extends LMChatroomActionEvent {
  final int chatroomId;
  final int conversationId;
  final Conversation topic;

  LMChatSetChatroomTopicEvent({
    required this.chatroomId,
    required this.conversationId,
    required this.topic,
  });

  @override
  List<Object> get props => [chatroomId, conversationId, topic];
}

class LMChatShareChatroomUrlEvent extends LMChatroomActionEvent {
  final int chatroomId;
  final String domain;

  LMChatShareChatroomUrlEvent({
    required this.chatroomId,
    required this.domain,
  });

  @override
  List<Object> get props => [chatroomId];
}

class LMChatShowEmojiKeyboardEvent extends LMChatroomActionEvent {
  final int conversationId;

  LMChatShowEmojiKeyboardEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class LMChatHideEmojiKeyboardEvent extends LMChatroomActionEvent {
  LMChatHideEmojiKeyboardEvent();

  @override
  List<Object?> get props => [];
}

class LMChatroomActionUpdateEvent extends LMChatroomActionEvent {
  final int chatroomId;

  LMChatroomActionUpdateEvent({
    required this.chatroomId,
  });

  @override
  List<Object> get props => [chatroomId];
}
