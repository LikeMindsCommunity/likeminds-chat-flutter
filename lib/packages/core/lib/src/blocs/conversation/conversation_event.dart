part of 'conversation_bloc.dart';

abstract class LMChatConversationEvent extends Equatable {}

class InitConversations extends LMChatConversationEvent {
  final int chatroomId;
  final int conversationId;

  InitConversations({
    required this.chatroomId,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [chatroomId, conversationId];
}

class LoadConversations extends LMChatConversationEvent {
  final GetConversationRequest getConversationRequest;

  LoadConversations({
    required this.getConversationRequest,
  });

  @override
  List<Object> get props => [getConversationRequest];
}

class PostConversation extends LMChatConversationEvent {
  final PostConversationRequest postConversationRequest;
  final Conversation? repliedTo;

  PostConversation({
    required this.postConversationRequest,
    this.repliedTo,
  });

  @override
  List<Object?> get props => [postConversationRequest, repliedTo];
}

class PostMultiMediaConversation extends LMChatConversationEvent {
  final PostConversationRequest postConversationRequest;
  final List<LMChatMedia> mediaFiles;

  PostMultiMediaConversation(
    this.postConversationRequest,
    this.mediaFiles,
  );

  @override
  List<Object> get props => [
        postConversationRequest,
        mediaFiles,
      ];
}

class UpdateConversations extends LMChatConversationEvent {
  final int conversationId;
  final int chatroomId;

  UpdateConversations({
    required this.conversationId,
    required this.chatroomId,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
      ];
}
