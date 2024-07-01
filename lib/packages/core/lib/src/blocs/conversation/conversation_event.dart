part of 'conversation_bloc.dart';

/// Abstract class representing a conversation event
abstract class LMChatConversationEvent extends Equatable {}

/// Event responsible for initialising LMChatConversationBloc
class LMChatInitialiseConversationsEvent extends LMChatConversationEvent {
  /// Id of the chatroom where conversations are being initialized
  final int chatroomId;

  /// Last conversation id of the chatroom of conversations
  final int conversationId;

  /// Creates and returns a new instance of initialize event
  LMChatInitialiseConversationsEvent({
    required this.chatroomId,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [chatroomId, conversationId];
}

/// Event responsible for fetching conversations in a chatroom
class LMChatFetchConversationsEvent extends LMChatConversationEvent {
  final GetConversationRequest getConversationRequest;

  /// Creates and returns a new instance of [LMChatFetchConversationsEvent]
  LMChatFetchConversationsEvent({
    required this.getConversationRequest,
  });

  @override
  List<Object> get props => [getConversationRequest];
}

/// Event responsible for creating and posting a new conversation
class LMChatPostConversationEvent extends LMChatConversationEvent {
  final PostConversationRequest postConversationRequest;
  final Conversation? repliedTo;

  /// Creates and returns a new instance of [LMChatPostConversationEvent]
  LMChatPostConversationEvent({
    required this.postConversationRequest,
    this.repliedTo,
  });

  @override
  List<Object?> get props => [postConversationRequest, repliedTo];
}

/// Event responsible for creating and posting a multimedia conversation
class LMChatPostMultiMediaConversationEvent extends LMChatConversationEvent {
  final PostConversationRequest postConversationRequest;
  final List<LMChatMedia> mediaFiles;

  /// Creates and returns a new instance of [LMChatPostMultiMediaConversationEvent]
  LMChatPostMultiMediaConversationEvent(
    this.postConversationRequest,
    this.mediaFiles,
  );

  @override
  List<Object> get props => [
        postConversationRequest,
        mediaFiles,
      ];
}

/// Event responsible for updating the conversations of a chatroom
///
/// This could be because of a realtime update, or a notification
class LMChatUpdateConversationsEvent extends LMChatConversationEvent {
  final int conversationId;
  final int chatroomId;

  /// Creates and returns a new instance of [LMChatUpdateConversationsEvent]
  LMChatUpdateConversationsEvent({
    required this.conversationId,
    required this.chatroomId,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
      ];
}
