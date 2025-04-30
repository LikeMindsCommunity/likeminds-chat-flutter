part of '../conversation_bloc.dart';

/// Handler for updating conversations in a chatroom
localConversationEventHandler(
  LMChatLocalConversationEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  int? lastConversationId = LMChatConversationBloc.instance.lastConversationId;
  if (lastConversationId != null &&
      event.conversation.id == lastConversationId) {
    return;
  }
  emit(LMChatLocalConversationState(event.conversation));
  lastConversationId = event.conversation.id;

  LMChatConversationBloc.instance.lastConversationId = lastConversationId;
}
