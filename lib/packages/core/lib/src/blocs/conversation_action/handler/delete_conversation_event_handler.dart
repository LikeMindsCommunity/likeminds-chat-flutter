part of "../conversation_action_bloc.dart";


/// Handles the delete conversation event
 _deleteConversationEventHandler(
      LMChatDeleteConversationEvent event, emit) async {
        debugPrint(event.conversationIds.toString());
    // create delete conversation request
    try {
      final DeleteConversationRequestBuilder deleteConversationRequestBuilder =
          DeleteConversationRequestBuilder()
            ..conversationIds(event.conversationIds)
            ..reason(event.reason);
      final response = await LMChatCore.client
          .deleteConversation(deleteConversationRequestBuilder.build());
      if (response.success) {
        emit(LMChatConversationDelete(response.data!));
      } else {
        emit(LMChatConversationDeleteError(
            response.errorMessage ?? 'An error occurred'));
      }
    } on Exception catch (e) {
      emit(LMChatConversationDeleteError(e.toString()));
    }
  }
