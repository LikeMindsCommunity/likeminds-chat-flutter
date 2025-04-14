part of 'conversation_action_bloc.dart';

@immutable

/// [LMChatConversationActionState] is the base class for all states in the [ConversationActionBloc].
abstract class LMChatConversationActionState extends Equatable {}

/// [LMChatConversationActionInitial] is the initial state of the [ConversationActionBloc].
class LMChatConversationActionInitial extends LMChatConversationActionState {
  @override
  List<Object> get props => [];
}

/// [LMChatConversationActionLoading] is the loading state of the [ConversationActionBloc].
class LMChatConversationActionError extends LMChatConversationActionState {
  /// The temporary id of the conversation
  final String temporaryId;

  /// The error message
  final String errorMessage;

  /// [LMChatConversationActionError] constructor
  LMChatConversationActionError(this.errorMessage, this.temporaryId);

  @override
  List<Object> get props => [
        temporaryId,
        errorMessage,
      ];
}

/// [LMChatConversationEdited] is the state when a conversation is edited.
class LMChatConversationEdited extends LMChatConversationActionState {
  /// The response of the edit conversation request
  final LMChatConversationViewData conversationViewData;

  /// [LMChatConversationEdited] constructor
  LMChatConversationEdited({
    required this.conversationViewData,
  });

  @override
  List<Object> get props => [
        conversationViewData,
      ];
}

/// [LMChatConversationDelete] is the state when a conversation is deleted.
class LMChatConversationDelete extends LMChatConversationActionState {
  /// List of conversations that are deleted
  final List<LMChatConversationViewData> conversations;

  /// [LMChatConversationDelete] constructor
  LMChatConversationDelete({
    required this.conversations,
  });

  @override
  List<Object> get props => [
        conversations,
      ];
}

/// [LMChatConversationDeleteError] is the state when an error occurs while deleting a conversation.
class LMChatConversationDeleteError extends LMChatConversationActionState {
  /// The error message
  final String errorMessage;

  /// [LMChatConversationDeleteError] constructor
  LMChatConversationDeleteError(this.errorMessage);

  @override
  List<Object> get props => [
        errorMessage,
      ];
}

/// [LMChatReplyConversationState] is the state when a conversation is replied.
class LMChatReplyConversationState extends LMChatConversationActionState {
  /// The chatroom id
  final int chatroomId;

  /// The conversation id
  final int conversationId;

  /// The conversation
  final LMChatConversationViewData conversation;

  final List<LMChatAttachmentViewData>? attachments;

  /// [LMChatReplyConversationState] constructor
  LMChatReplyConversationState({
    required this.chatroomId,
    required this.conversationId,
    required this.conversation,
    this.attachments,
  });

  @override
  List<Object> get props => [
        chatroomId,
        conversationId,
      ];
}

/// [LMChatReplyRemoveState] is the state when a reply is removed.
class LMChatReplyRemoveState extends LMChatConversationActionState {
  /// time in milliseconds
  final int time = DateTime.now().millisecondsSinceEpoch;
  @override
  List<Object> get props => [time];
}

/// [LMChatEditConversationState] is the state when a conversation is edited.
class LMChatEditConversationState extends LMChatConversationActionState {
  /// The chatroom id
  final int chatroomId;

  /// The conversation id
  final int conversationId;

  /// The conversation
  final LMChatConversationViewData editConversation;

  /// [LMChatEditConversationState] constructor
  LMChatEditConversationState({
    required this.chatroomId,
    required this.conversationId,
    required this.editConversation,
  });

  @override
  List<Object> get props => [
        chatroomId,
        conversationId,
        editConversation,
      ];
}

/// [LMChatEditRemoveState] is the state when an edit is removed.
class LMChatEditRemoveState extends LMChatConversationActionState {
  @override
  List<Object> get props => [];
}

class LMChatRefreshBarState extends LMChatConversationActionState {
  final LMChatRoomViewData chatroom;

  LMChatRefreshBarState({
    required this.chatroom,
  });

  @override
  List<Object> get props => [chatroom];
}

/// {@template lm_chat_link_attached_state}
/// It is the state when a link is attached to the conversation.
/// [ogTags] - The Open Graph tags of the link
/// [link] - The link
/// {@endtemplate}
class LMChatLinkAttachedState extends LMChatConversationActionState {
  /// The Open Graph tags of the link
  final LMChatOGTagsViewData ogTags;

  /// The link
  final String link;

  /// {@macro lm_chat_link_attached_state}
  LMChatLinkAttachedState({
    required this.ogTags,
    required this.link,
  });

  @override
  List<Object> get props => [
        ogTags,
        link,
      ];
}

/// {@template lm_chat_link_removed_state}
/// It is the state when a link is removed from the conversation.
/// [isPermanentlyRemoved] - If the link is permanently removed
/// {@endtemplate}
class LMChatLinkRemovedState extends LMChatConversationActionState {
  /// If the link is permanently removed
  final bool isPermanentlyRemoved;

  /// {@macro lm_chat_link_removed_state}
  LMChatLinkRemovedState({
    this.isPermanentlyRemoved = false,
  });

  @override
  List<Object> get props => [
        isPermanentlyRemoved,
      ];
}

class LMChatPutReactionState extends LMChatConversationActionState {
  final int conversationId;
  final String reaction;

  LMChatPutReactionState({
    required this.conversationId,
    required this.reaction,
  });

  @override
  List<Object> get props => [conversationId, reaction];
}

class LMChatPutReactionError extends LMChatConversationActionState {
  final String errorMessage;
  final int conversationId;
  final String reaction;

  LMChatPutReactionError({
    required this.errorMessage,
    required this.conversationId,
    required this.reaction,
  });

  @override
  List<Object> get props => [errorMessage, conversationId, reaction];
}

class LMChatDeleteReactionState extends LMChatConversationActionState {
  final int conversationId;
  final String reaction;

  LMChatDeleteReactionState({
    required this.conversationId,
    required this.reaction,
  });

  @override
  List<Object> get props => [conversationId, reaction];
}

class LMChatDeleteReactionError extends LMChatConversationActionState {
  final String errorMessage;
  final int conversationId;
  final String reaction;

  LMChatDeleteReactionError({
    required this.errorMessage,
    required this.conversationId,
    required this.reaction,
  });

  @override
  List<Object> get props => [errorMessage, conversationId, reaction];
}

/// Search conversation state
class LMChatSearchConversationInChatroomState
    extends LMChatConversationActionState {
  /// The search query.
  final LMChatConversationViewData conversation;

  /// Creates and returns a new instance of [LMChatSearchConversationInChatroomState]
  LMChatSearchConversationInChatroomState(this.conversation);
  @override
  List<Object> get props => [conversation];
}
