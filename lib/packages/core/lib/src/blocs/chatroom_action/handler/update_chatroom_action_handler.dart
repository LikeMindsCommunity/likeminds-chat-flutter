part of '../chatroom_action_bloc.dart';

/// Function to handle update Chatroom Action events,
/// emits appropriate state based on response,
/// and updates the chatroom actions
Future<void> _updateChatroomActionHandler(
  LMChatroomActionUpdateEvent event,
  Emitter<LMChatroomActionState> emit,
) async {
  // Fetching the chatroom using LMChatClient
  LMResponse<GetChatroomResponse> response =
      await LMChatCore.client.getChatroom(
    (GetChatroomRequestBuilder()..chatroomId(event.chatroomId)).build(),
  );

  if (response.success) {
    //Success, now continue with parsing the response
    final ChatRoom chatroom = response.data!.chatroom!;

    //Finally, emit the loaded success state with the chatroom response
    emit(
      LMChatroomActionUpdateState(
        chatroom: chatroom,
        actions: response.data!.chatroomActions!,
      ),
    );
  } else {
    emit(
        LMChatroomActionUpdateErrorState(errorMessage: response.errorMessage!));
  }
}
