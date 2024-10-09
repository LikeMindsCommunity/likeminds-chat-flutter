part of '../chatroom_action_bloc.dart';

Future<void> _handleSetChatroomTopic(LMChatSetChatroomTopicEvent event,
    Emitter<LMChatroomActionState> emit) async {
  try {
    emit(LMChatChatroomActionLoading());
    LMResponse<void> response = await LMChatCore.client
        .setChatroomTopic((SetChatroomTopicRequestBuilder()
              ..chatroomId(event.chatroomId)
              ..conversationId(event.conversationId))
            .build());
    if (response.success) {
      emit(LMChatChatroomTopicSet(event.topic));
    } else {
      emit(LMChatChatroomTopicError(errorMessage: response.errorMessage!));
    }
  } catch (e) {
    emit(LMChatChatroomTopicError(
        errorMessage: "An error occurred while setting topic"));
  }
}
