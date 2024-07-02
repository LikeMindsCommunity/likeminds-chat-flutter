part of '../explore_bloc.dart';

/// Function to handle fetching exlplore feed event
fetchExploreEventHandler(
  LMChatFetchExploreEvent event,
  Emitter<LMChatExploreState> emit,
) async {
  emit(LMChatExploreLoadingState());
  LMResponse response = await LMChatCore.instance.lmChatClient
      .getExploreFeed(event.getExploreFeedRequest);
  if (response.success) {
    GetExploreFeedResponse getExploreFeedResponse =
        response.data as GetExploreFeedResponse;
    emit(LMChatExploreLoadedState(getExploreFeedResponse));
  } else {
    emit(LMChatExploreErrorState(response.errorMessage!));
  }
}
