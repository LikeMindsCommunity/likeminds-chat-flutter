part of "../search_conversation_bloc.dart";

/// Event handler for [LMChatSearchConversationEvent]
void _searchConversationEventHandler(LMChatGetSearchConversationEvent event,
    Emitter<LMChatSearchConversationState> emit) async {
  // Emit loading state based on whether it's a new search or pagination
  if (event.search.trim().isEmpty) {
    emit(const LMChatSearchConversationInitial());
    return;
  }
  if (event.page > 1) {
    emit(const LMChatSearchConversationPaginationLoadingState());
  } else {
    emit(const LMChatSearchConversationLoadingState());
  }
  try {
    // Create the search conversation request
    final ConversationSearchRequest searchRequest =
        (ConversationSearchRequestBuilder()
              ..searchTerm(event.search)
              ..followStatus(event.followStatus)
              ..page(event.page)
              ..pageSize(event.pageSize)
              ..chatroomId(event.chatroomId))
            .build();

    // Fetch the search results from the repository
    final LMResponse<ConversationSearchResponse> response =
        await LMChatCore.client.searchConversation(searchRequest);
    // Check if the response is successful
    if (response.success) {
      // Extract the search results from the response
      ConversationSearchResponse searchResponse = response.data!;
      List<LMChatConversationViewData> results = searchResponse.conversations
              ?.map((conversation) => conversation.toConversationViewData())
              .toList() ??
          [];

      // Emit the loaded state with the search results and current page
      emit(
        LMChatSearchConversationLoadedState(
          results: results,
          page: event.page,
        ),
      );
    } else {
      // Emit error state with the error message
      emit(
        LMChatSearchConversationErrorState(
          errorMessage:
              response.errorMessage ?? "Error in fetching search results",
        ),
      );
    }
  } catch (e) {
    // Emit error state if an exception occurs
    emit(
      LMChatSearchConversationErrorState(
        errorMessage: e.toString(),
      ),
    );
  }
}
