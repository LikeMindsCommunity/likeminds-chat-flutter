part of '../conversation_bloc.dart';

/// Handler responsible for fetching conversation event
fetchConversationsEventHandler(
  LMChatFetchConversationsEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  emit(LMChatConversationLoadingState());
  LMResponse response =
      await LMChatCore.client.getConversation(event.getConversationRequest);
  if (response.success) {
    GetConversationResponse conversationResponse = response.data;
    for (var element in conversationResponse.conversationData!) {
      element.member = conversationResponse.userMeta?[element.memberId];
    }
    for (var element in conversationResponse.conversationData!) {
      String? replyId = element.replyId == null
          ? element.replyConversation?.toString()
          : element.replyId.toString();
      element.replyConversationObject =
          conversationResponse.conversationMeta?[replyId];
      element.replyConversationObject?.member = conversationResponse
          .userMeta?[element.replyConversationObject?.memberId];
    }
    emit(LMChatConversationLoadedState(conversationResponse));
  } else {
    emit(LMChatConversationErrorState(response.errorMessage!, ''));
  }
}
