part of "../conversation_action_bloc.dart";

// Handles the reply conversation event
_replyEventHandler(LMChatReplyConversationEvent event, emit) async {
  emit(LMChatReplyConversationState(
    chatroomId: event.chatroomId,
    conversationId: event.conversationId,
    conversation: event.replyConversation,
  ));
}

// Handles the remove reply event

_replyRemoveEventHandler(LMChatReplyRemoveEvent event, emit) async {
  emit(LMChatReplyRemoveState());
}
