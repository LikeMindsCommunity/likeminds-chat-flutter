part of 'conversation_action_bloc.dart';

/// [LMChatConversationActionEvent] is the base class for all the events related to conversation actions.
@immutable
abstract class LMChatConversationActionEvent extends Equatable {}

///
class LMChatEditConversationEvent extends LMChatConversationActionEvent {
  final EditConversationRequest editConversationRequest;
  final Conversation? replyConversation;

  LMChatEditConversationEvent(this.editConversationRequest,
      {this.replyConversation});

  @override
  List<Object> get props => [
        editConversationRequest,
      ];
}

class LMChatEditingConversationEvent extends LMChatConversationActionEvent {
  final int conversationId;
  final int chatroomId;
  final Conversation editConversation;

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

/// [LMChatDeleteConversationEvent] is used to delete a conversation.
class LMChatDeleteConversationEvent extends LMChatConversationActionEvent {
  /// [List<int>] conversationIds is the list of conversation ids to be deleted.
  final List<int> conversationIds;

  /// [String] reason is the reason for deleting the conversation.
  final String reason;

  /// [LMChatDeleteConversationEvent] constructor to create an instance of [LMChatDeleteConversationEvent].
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

class LMChatReplyConversationEvent extends LMChatConversationActionEvent {
  final int conversationId;
  final int chatroomId;
  final Conversation replyConversation;

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

class LMChatReplyRemoveEvent extends LMChatConversationActionEvent {
  final int time = DateTime.now().millisecondsSinceEpoch;
  @override
  List<Object> get props => [time];
}
