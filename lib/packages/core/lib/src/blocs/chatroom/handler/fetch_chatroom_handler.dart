part of '../chatroom_bloc.dart';

/// Function to handle fetch Home Feed events,
/// emits appropriate state based on response,
/// and converts models to view data models
void fetchChatroomEventHandler(
  LMChatFetchChatroomEvent event,
  Emitter<LMChatroomState> emit,
) async {
  emit(LMChatroomLoadingState());

  // Fetching the chatroom using LMChatClient
  LMResponse<GetChatroomResponse> response =
      await LMChatCore.client.getChatroom(
    (GetChatroomRequestBuilder()..chatroomId(event.chatroomId)).build(),
  );

  //Emit error state and fail gracefully
  if (!response.success) {
    emit(LMChatroomErrorState(
      response.errorMessage ?? LMChatStringConstants.errorFallback,
    ));
  }

  //Success, now continue with parsing the response
  final ChatRoom chatroom = response.data!.chatroom!;

  //Finally, emit the loaded success state with the chatroom response
  emit(
    LMChatroomLoadedState(
      chatroom: chatroom,
      actions: response.data!.chatroomActions!,
      participantCount: response.data!.participantCount ?? 0,
      lastConversationId: response.data!.lastConversationId ?? 0,
    ),
  );
}
