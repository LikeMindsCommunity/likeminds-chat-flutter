part of 'conversation_action_bloc.dart';

/// [LMChatConversationActionEvent] is the base class for all the events related to conversation actions.
@immutable
abstract class LMChatConversationActionEvent extends Equatable {}

///{@template lm_chat_edit_conversation_event}
/// [LMChatEditConversationEvent] is used to edit a conversation.
/// It extends [LMChatConversationActionEvent] and has the following properties:
/// - [EditConversationRequest] editConversationRequest is the request to edit a conversation.
/// - [Conversation] replyConversation is the conversation to be replied.
/// {@endtemplate}
class LMChatEditConversationEvent extends LMChatConversationActionEvent {
  /// [EditConversationRequest] editConversationRequest is the request to edit a conversation.
  final EditConversationRequest editConversationRequest;

  /// [Conversation] replyConversation is the conversation to be replied.
  final Conversation? replyConversation;

  /// {@macro lm_chat_edit_conversation_event}
  LMChatEditConversationEvent(this.editConversationRequest,
      {this.replyConversation});

  @override
  List<Object> get props => [
        editConversationRequest,
      ];
}

/// {@template lm_chat_editing_conversation_event}
/// [LMChatEditingConversationEvent] is used to edit a conversation.
/// It extends [LMChatConversationActionEvent] and has the following properties:
/// - [int] conversationId is the id of the conversation to be edited.
/// - [int] chatroomId is the id of the chatroom.
/// - [LMChatConversationViewData] editConversation is the conversation to be edited.
/// {@endtemplate}
class LMChatEditingConversationEvent extends LMChatConversationActionEvent {
  /// [int] conversationId is the id of the conversation to be edited.
  final int conversationId;

  /// [int] chatroomId is the id of the chatroom.
  final int chatroomId;

  /// [LMChatConversationViewData] editConversation is the conversation to be edited.
  final LMChatConversationViewData editConversation;

  /// {@macro lm_chat_editing_conversation_event}
  LMChatEditingConversationEvent({
    required this.conversationId,
    required this.chatroomId,
    required this.editConversation,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
        editConversation,
      ];
}

class LMChatEditRemoveEvent extends LMChatConversationActionEvent {
  @override
  List<Object> get props => [];
}

/// {@macro lm_chat_delete_conversation_event} is used to delete a conversation.
class LMChatDeleteConversationEvent extends LMChatConversationActionEvent {
  /// [List<int>] conversationIds is the list of conversation ids to be deleted.
  final List<int> conversationIds;

  /// [String] reason is the reason for deleting the conversation.
  final String reason;

  /// {@macro lm_chat_delete_conversation_event}
  LMChatDeleteConversationEvent({
    required this.conversationIds,
    this.reason = "Delete",
  });

  @override
  List<Object> get props => [
        conversationIds,
        reason,
      ];
}

/// {@macro lm_chat_reply_conversation_event} is used to reply to a conversation.
class LMChatReplyConversationEvent extends LMChatConversationActionEvent {
  /// [int] conversationId is the id of the conversation to be replied.
  final int conversationId;

  /// [int] chatroomId is the id of the chatroom.
  final int chatroomId;

  /// [LMChatConversationViewData] replyConversation is the conversation to be replied.
  final LMChatConversationViewData replyConversation;

  final List<LMChatAttachmentViewData>? attachments;

  /// {@macro lm_chat_reply_conversation_event}
  LMChatReplyConversationEvent({
    required this.conversationId,
    required this.chatroomId,
    required this.replyConversation,
    required this.attachments,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
        replyConversation,
      ];
}

/// {@macro lm_chat_reply_remove_event} is used to remove the reply state.
class LMChatReplyRemoveEvent extends LMChatConversationActionEvent {
  /// [int] time is the time in milliseconds.
  final int time = DateTime.now().millisecondsSinceEpoch;
  @override
  List<Object> get props => [time];
}

/// {@macro lm_chat_refresh_bar_event} is used to refresh the chatroom bar.}
class LMChatRefreshBarEvent extends LMChatConversationActionEvent {
  final LMChatRoomViewData chatroom;

  LMChatRefreshBarEvent({
    required this.chatroom,
  });

  @override
  List<Object> get props => [chatroom];
}

class LMChatConversationTextChangeEvent extends LMChatConversationActionEvent {
  final String text;
  final String previousLink;

  LMChatConversationTextChangeEvent({
    required this.text,
    required this.previousLink,
  });

  @override
  List<Object> get props => [text, previousLink];
}

class LMChatLinkPreviewRemovedEvent extends LMChatConversationActionEvent {
  final bool isPermanentlyRemoved;
  LMChatLinkPreviewRemovedEvent({
    this.isPermanentlyRemoved = false,
  });
  @override
  List<Object> get props => [
        isPermanentlyRemoved,
      ];
}

class LMChatPutReaction extends LMChatConversationActionEvent {
  final int conversationId;
  final String reaction;

  LMChatPutReaction({
    required this.conversationId,
    required this.reaction,
  });

  @override
  List<Object> get props => [
        conversationId,
        reaction,
      ];
}

class LMChatDeleteReaction extends LMChatConversationActionEvent {
  final int conversationId;
  final String reaction;

  LMChatDeleteReaction({
    required this.conversationId,
    required this.reaction,
  });

  @override
  List<Object> get props => [
        conversationId,
        reaction,
      ];
}

/// Event responsible for searching conversations in a chatroom
class LMChatSearchConversationInChatroomEvent
    extends LMChatConversationActionEvent {
  /// The message id to search for
  final int messageId;

  /// Creates and returns a new instance of [LMChatSearchConversationInChatroomEvent]
  LMChatSearchConversationInChatroomEvent({
    required this.messageId,
  });

  @override
  List<Object> get props => [messageId];
}
