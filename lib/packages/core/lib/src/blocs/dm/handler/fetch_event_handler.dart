part of '../dm_bloc.dart';

/// Function to handle fetch DM Feed events,
/// emits appropriate state based on response,
/// and converts models to view data models
void fetchDMFeedEventHandler(
  LMChatFetchDMFeedEvent event,
  Emitter<LMChatDMFeedState> emit,
) async {
  emit(LMChatDMFeedLoading());

  //Fetching the current time for the request
  int currentTime = DateTime.now().millisecondsSinceEpoch;

  //Building request and calling the `getHomeFeed` function of the client
  final response =
      await LMChatCore.client.getHomeFeed((GetHomeFeedRequestBuilder()
            ..page(event.page)
            ..pageSize(50)
            ..minTimestamp(0)
            ..maxTimestamp(currentTime)
            ..chatroomTypes([10]))
          .build());

  //Emit error state and fail gracefully
  if (!response.success) {
    emit(LMChatDMFeedError(
      errorMessage: response.errorMessage ?? errorFallback,
    ));
  }

  //Success, now continue with parsing the response
  final List<ChatRoom> chatrooms;
  final Map<String, Conversation> conversationMeta;
  final Map<int, User>? users;
  (chatrooms, users, conversationMeta) = parseResponse(response.data!);

  //Finally, emit the loaded success state to show the DM Feed
  emit(LMChatDMFeedLoaded(
    chatrooms: chatrooms,
    conversationMeta: conversationMeta,
    userMeta: users,
  ));
}

/// Function to parse the response object into respective view model,
/// Returns a pattern of required view models.
(
  List<ChatRoom> chatrooms,
  Map<int, User> user,
  Map<String, Conversation> conversationMeta,
) parseResponse(GetHomeFeedResponse response) {
  //TODO: Replace with view model implementation
  return (
    response.chatroomsData!,
    response.userMeta!,
    response.conversationMeta!,
  );
}
