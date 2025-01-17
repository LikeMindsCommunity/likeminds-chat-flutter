part of '../home_bloc.dart';

/// Function to handle fetch Home Feed events,
/// emits appropriate state based on response,
/// and converts models to view data models
void refreshHomeFeedEventHandler(
  LMChatRefreshHomeFeedEvent event,
  Emitter<LMChatHomeFeedState> emit,
) async {
  emit(LMChatHomeFeedLoading());

  //Fetching the current time for the request
  int currentTime = DateTime.now().millisecondsSinceEpoch;

  //Building request and calling the `getHomeFeed` function of the client
  final response =
      await LMChatCore.client.getHomeFeed((GetHomeFeedRequestBuilder()
            ..page(1)
            ..pageSize(50)
            ..minTimestamp(0)
            ..maxTimestamp(currentTime)
            ..tag(event.tag)
            ..chatroomTypes([0, 7]))
          .build());

  //Emit error state and fail gracefully
  if (!response.success) {
    emit(LMChatHomeFeedError(
      errorMessage:
          response.errorMessage ?? LMChatStringConstants.errorFallback,
    ));
  }

  //Success, now continue with parsing the response
  final List<LMChatRoomViewData> chatrooms = parseHomeResponse(response.data!);

  //Finally, emit the loaded success state to show the DM Feed
  emit(LMChatHomeFeedUpdated(chatrooms: chatrooms));
}
