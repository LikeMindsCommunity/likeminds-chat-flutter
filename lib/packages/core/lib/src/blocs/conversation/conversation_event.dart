part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {}

class InitConversations extends ConversationEvent {
  final int chatroomId;
  final int conversationId;

  InitConversations({
    required this.chatroomId,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [chatroomId, conversationId];
}

class LoadConversations extends ConversationEvent {
  final GetConversationRequest getConversationRequest;

  LoadConversations({
    required this.getConversationRequest,
  });

  @override
  List<Object> get props => [getConversationRequest];
}

class PostConversation extends ConversationEvent {
  final PostConversationRequest postConversationRequest;
  final Conversation? repliedTo;

  PostConversation({
    required this.postConversationRequest,
    this.repliedTo,
  });

  @override
  List<Object?> get props => [postConversationRequest, repliedTo];
}

class PostMultiMediaConversation extends ConversationEvent {
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

class UpdateConversations extends ConversationEvent {
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
