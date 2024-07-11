part of '../explore_bloc.dart';

/// Handler to handle refresh explore event
void refreshExploreEventHandler(
  LMChatRefreshExploreEvent event,
  Emitter<LMChatExploreState> emit,
) async {
  emit(LMChatExploreLoadingState());
  LMResponse response = await LMChatCore.instance.lmChatClient
      .getExploreFeed((GetExploreFeedRequestBuilder()
            ..orderType(event.orderType)
            ..page(1)
            ..pinned(event.pinned))
          .build());
  if (response.success) {
    GetExploreFeedResponse getExploreFeedResponse =
        response.data as GetExploreFeedResponse;
    emit(LMChatExploreLoadedState(getExploreFeedResponse));
  } else {
    emit(LMChatExploreErrorState(response.errorMessage!));
  }
}
