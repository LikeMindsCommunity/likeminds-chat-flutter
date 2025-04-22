part of '../conversation_action_bloc.dart';

/// Handles the search conversation in chatroom event.
void _searchConversationInChatroomEventHandler(
    LMChatSearchConversationInChatroomEvent event,
    Emitter<LMChatConversationActionState> emit) async {
  emit(LMChatSearchConversationInChatroomState(event.conversation));
}
