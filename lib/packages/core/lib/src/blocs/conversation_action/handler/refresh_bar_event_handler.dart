part of '../conversation_action_bloc.dart';

_refreshBarEventHandler(LMChatRefreshBarEvent event, emit) {
  emit(LMChatRefreshBarState(chatroom: event.chatroom));
}
