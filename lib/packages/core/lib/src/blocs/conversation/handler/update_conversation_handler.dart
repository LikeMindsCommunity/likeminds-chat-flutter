part of '../conversation_bloc.dart';

/// Handler for updating conversations in a chatroom
updateConversationsEventHandler(
  LMChatUpdateConversationsEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  int? lastConversationId = LMChatConversationBloc.instance.lastConversationId;
  if (lastConversationId != null &&
      event.conversationId != lastConversationId) {
    int maxTimestamp = DateTime.now().millisecondsSinceEpoch;
    final response =
        await LMChatCore.client.getConversation((GetConversationRequestBuilder()
              ..chatroomId(event.chatroomId)
              ..minTimestamp(0)
              ..maxTimestamp(maxTimestamp * 1000)
              ..isLocalDB(false)
              ..page(1)
              ..pageSize(5)
              ..conversationId(event.conversationId))
            .build());
    if (response.success) {
      GetConversationResponse conversationResponse = response.data!;
      for (var element in conversationResponse.conversationData!) {
        element.member =
            conversationResponse.userMeta?[element.userId ?? element.memberId];
      }
      for (var element in conversationResponse.conversationData!) {
        String? replyId = element.replyId == null
            ? element.replyConversation?.toString()
            : element.replyId.toString();
        element.replyConversationObject =
            conversationResponse.conversationMeta?[replyId];
        element.replyConversationObject?.member =
            conversationResponse.userMeta?[
                element.replyConversationObject?.userId ??
                    element.replyConversationObject?.memberId];
      }
      Conversation realTimeConversation =
          response.data!.conversationData!.first;
      if (response.data!.conversationMeta != null &&
          realTimeConversation.replyId != null) {
        Conversation? replyConversationObject = response
            .data!.conversationMeta![realTimeConversation.replyId.toString()];
        realTimeConversation.replyConversationObject = replyConversationObject;
      }
      emit(
        LMChatConversationUpdatedState(
          response: realTimeConversation,
        ),
      );
      lastConversationId = event.conversationId;
    }
  }
  LMChatConversationBloc.instance.lastConversationId = lastConversationId;
}
