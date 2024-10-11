part of '../chatroom_action_bloc.dart';

void _handleShowEmojiKeyboard(
    LMChatShowEmojiKeyboardEvent event, Emitter<LMChatroomActionState> emit) {
  emit(LMChatShowEmojiKeyboardState(
    conversationId: event.conversationId,
  ));
}
