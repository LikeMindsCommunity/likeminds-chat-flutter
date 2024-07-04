part of 'conversation_action_bloc.dart';

/// [LMChatConversationActionEvent] is the base class for all the events related to conversation actions.
@immutable
abstract class LMChatConversationActionEvent extends Equatable {}

///{@macro lm_chat_edit_conversation_event}  is used to edit a conversation.
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


/// {@macro lm_chat_editing_conversation_event} is used to emit an editing conversation state.
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

/// {@macro lm_chat_edit_remove_event} is used to remove the editing state.
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

  /// {@macro lm_chat_reply_conversation_event}
  LMChatReplyConversationEvent({
    required this.conversationId,
    required this.chatroomId,
    required this.replyConversation,
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
