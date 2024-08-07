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
  /// Id of the chatroom where conversations are being fetched
  final int chatroomId;

  /// Page number of the conversations
  final int page;

  /// Number of conversations to be fetched
  final int pageSize;

  /// Creates and returns a new instance of [LMChatFetchConversationsEvent]
  LMChatFetchConversationsEvent({
    required this.chatroomId,
    required this.page,
    required this.pageSize,
  });

  @override
  List<Object> get props => [
        chatroomId,
        page,
        pageSize,
      ];
}

/// Event responsible for creating and posting a new conversation
class LMChatPostConversationEvent extends LMChatConversationEvent {
  /// Text of the conversation
  final String text;

  /// Chatroom id where the conversation is to be posted
  final int chatroomId;

  /// Id of the conversation being replied to if any
  final int? replyId;

  /// Reply object of the conversation being replied to if any
  final LMChatConversationViewData? repliedTo;

  /// Link String if present
  final String? shareLink;

  /// Attachment count of the conversation
  final int? attachmentCount;

  /// Has files of the conversation
  final bool? hasFiles;

  /// Creates and returns a new instance of [LMChatPostConversationEvent]
  LMChatPostConversationEvent({
    required this.chatroomId,
    required this.text,
    this.replyId,
    this.repliedTo,
    this.shareLink,
    this.attachmentCount,
    this.hasFiles,
  });

  @override
  List<Object?> get props => [
        chatroomId,
        text,
        replyId,
        repliedTo,
        shareLink,
        attachmentCount,
        hasFiles,
      ];
}

/// Event responsible for creating and posting a multimedia conversation
class LMChatPostMultiMediaConversationEvent extends LMChatConversationEvent {
  final PostConversationRequest postConversationRequest;
  final List<LMChatMediaModel> mediaFiles;

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
  /// Id of the conversation to be updated
  final int conversationId;

  /// Id of the chatroom where the conversation is to be updated
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

class LMChatLocalConversationEvent extends LMChatConversationEvent {
  final LMChatConversationViewData conversation;

  LMChatLocalConversationEvent({
    required this.conversation,
  });

  @override
  List<Object> get props => [
        conversation,
      ];
}
