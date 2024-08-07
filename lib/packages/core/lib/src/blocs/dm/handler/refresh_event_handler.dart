part of '../dm_bloc.dart';

/// Function to handle fetch DM Feed events,
/// emits appropriate state based on response,
/// and converts models to view data models
void refreshDMFeedEventHandler(
  LMChatRefreshDMFeedEvent event,
  Emitter<LMChatDMFeedState> emit,
) async {
  emit(LMChatDMFeedLoading());

  //Fetching the current time for the request
  int currentTime = DateTime.now().millisecondsSinceEpoch;

  //Building request and calling the `getHomeFeed` function of the client
  final response =
      await LMChatCore.client.getHomeFeed((GetHomeFeedRequestBuilder()
            ..page(1)
            ..pageSize(50)
            ..minTimestamp(0)
            ..maxTimestamp(currentTime)
            ..chatroomTypes([10]))
          .build());

  //Emit error state and fail gracefully
  if (!response.success) {
    emit(LMChatDMFeedError(
      errorMessage:
          response.errorMessage ?? LMChatStringConstants.errorFallback,
    ));
  }

  //Success, now continue with parsing the response
  final List<LMChatRoomViewData> chatrooms = parseDMResponse(response.data!);

  //Finally, emit the loaded success state to show the DM Feed
  emit(LMChatDMFeedUpdated(chatrooms: chatrooms));
}
