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

  /// [LMChatReplyConversationState] constructor
  LMChatReplyConversationState({
    required this.chatroomId,
    required this.conversationId,
    required this.conversation,
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
