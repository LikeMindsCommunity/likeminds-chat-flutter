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

  final int? minTimestamp;
  final int? maxTimestamp;
  final LMPaginationDirection direction;
  final int? lastConversationId;
  final int? replyId;
  final OrderBy? orderBy;

  /// Creates and returns a new instance of [LMChatFetchConversationsEvent]
  LMChatFetchConversationsEvent({
    required this.chatroomId,
    required this.page,
    required this.pageSize,
    required this.direction,
    required this.lastConversationId,
    this.minTimestamp,
    this.maxTimestamp,
    this.replyId,
    this.orderBy,
  });

  @override
  List<Object> get props => [
        chatroomId,
        page,
        pageSize,
        direction,
        lastConversationId ?? -1,
        minTimestamp ?? 0,
        maxTimestamp ?? 0,
        replyId ?? -1,
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

  /// Trigger bot of the conversation
  final bool? triggerBot;

  /// Creates and returns a new instance of [LMChatPostConversationEvent]
  LMChatPostConversationEvent({
    required this.chatroomId,
    required this.text,
    this.replyId,
    this.repliedTo,
    this.shareLink,
    this.attachmentCount,
    this.hasFiles,
    this.triggerBot,
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
        triggerBot,
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

  /// check if the conversation should be updated explicitly
  /// irrespective of the last conversation id
  /// This is useful when editing a poll
  final bool shouldUpdate;

  /// Creates and returns a new instance of [LMChatUpdateConversationsEvent]
  LMChatUpdateConversationsEvent({
    required this.conversationId,
    required this.chatroomId,
    this.shouldUpdate = false,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
        shouldUpdate,
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

/// {@template lm_chat_post_poll_conversation_event}
/// Event responsible for creating and posting a poll conversation
/// {@endtemplate}
class LMChatPostPollConversationEvent extends LMChatConversationEvent {
  /// The ID of the chatroom.
  final int chatroomId;

  /// The text content of the conversation.
  final String text;

  /// The state of the conversation.
  final int state;

  /// A list of poll options.
  final List<String> polls;

  /// The type of the poll.
  final int pollType;

  /// The state of multiple selection.
  final int multipleSelectState;

  /// The number of multiple selections allowed.
  final int multipleSelectNo;

  /// Indicates if the conversation is anonymous.
  final bool isAnonymous;

  /// Allows adding options to the poll.
  final bool allowAddOption;

  /// The expiry time of the poll.
  final int? expiryTime;

  /// A temporary ID for the conversation.
  final String temporaryId;

  /// The ID of the replied conversation, if any.
  final String? repliedConversationId;

  /// Indicates if the poll has no expiry.
  /// If true, the poll will not expire.
  final bool? noPollExpiry;

  /// Indicates if the vote can be changed.
  /// If true, the user can change their vote.
  /// in case of open and instant polls, the user can change their vote.
  /// in case of deferred polls, it is set to true.
  final bool? allowVoteChange;

  /// {@macro lm_chat_post_poll_conversation_event}
  LMChatPostPollConversationEvent({
    required this.chatroomId,
    required this.text,
    this.state = 10,
    required this.polls,
    required this.pollType,
    required this.multipleSelectState,
    required this.multipleSelectNo,
    required this.isAnonymous,
    required this.allowAddOption,
    this.expiryTime,
    required this.temporaryId,
    this.repliedConversationId,
    this.noPollExpiry,
    this.allowVoteChange,
  });

  @override
  List<Object> get props => [
        chatroomId,
        text,
        state,
        polls,
        pollType,
        multipleSelectState,
        multipleSelectNo,
        isAnonymous,
        allowAddOption,
        expiryTime ?? -1,
        temporaryId,
        repliedConversationId ?? -1,
        noPollExpiry ?? false,
        allowVoteChange ?? false,
      ];
}
