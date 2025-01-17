part of '../conversation_bloc.dart';

/// Handler responsible for fetching conversation event
fetchConversationsEventHandler(
  LMChatFetchConversationsEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  emit(LMChatConversationLoadingState());
  final currentTime = DateTime.now().millisecondsSinceEpoch;
  final int minTimestamp = event.minTimestamp ?? 0;
  final int maxTimestamp = event.maxTimestamp ?? currentTime;
  final GetConversationRequestBuilder getConversationRequestBuilder =
      GetConversationRequestBuilder()
        ..chatroomId(event.chatroomId)
        ..page(event.page)
        ..pageSize(event.pageSize)
        ..isLocalDB(false)
        ..minTimestamp(minTimestamp)
        ..orderBy(event.orderBy ?? OrderBy.descending)
        ..maxTimestamp(maxTimestamp);
  if (event.replyId != null) {
    getConversationRequestBuilder.conversationId(event.replyId!);
  }
  LMResponse response = await LMChatCore.client
      .getConversation(getConversationRequestBuilder.build());
  if (response.success) {
    GetConversationResponse conversationResponse = response.data;
    for (var element in conversationResponse.conversationData!) {
      //Assigning member to the conversation from userMeta
      element.member = conversationResponse.userMeta?[element.memberId];
      //Assigning reply to the conversation from conversationMeta
      String? replyId = element.replyId == null
          ? element.replyConversation?.toString()
          : element.replyId.toString();
      element.replyConversationObject =
          conversationResponse.conversationMeta?[replyId];
      element.replyConversationObject?.member = conversationResponse
          .userMeta?[element.replyConversationObject?.memberId];
      //Assigning attachment to the conversation from attachmentMeta
    }
    emit(LMChatConversationLoadedState(
      conversationResponse,
      event.direction,
      event.page,
      reInitialize: event.reInitialize,
    ));
  } else {
    emit(LMChatConversationErrorState(response.errorMessage!, ''));
  }
}
