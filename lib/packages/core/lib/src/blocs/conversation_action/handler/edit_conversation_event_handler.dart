part of "../conversation_action_bloc.dart";

_editConversationEventHandler(LMChatEditConversationEvent event,
    Emitter<LMChatConversationActionState> emit) async {
  emit(LMChatEditRemoveState());
  try {
    LMResponse<EditConversationResponse> response =
        await LMChatCore.client.editConversation(
      event.editConversationRequest,
    );

    if (response.success) {
      Conversation conversation = response.data!.conversation!;
      if (conversation.replyId != null ||
          conversation.replyConversation != null) {
        conversation.replyConversationObject = event.replyConversation;
      }
      emit(
        LMChatConversationEdited(
          conversationViewData: conversation.toConversationViewData(),
        ),
      );
    } else {
      emit(
        LMChatConversationActionError(
          response.errorMessage!,
          event.editConversationRequest.conversationId.toString(),
        ),
      );
      return false;
    }
  } catch (e) {
    emit(
      LMChatConversationActionError(
        "An error occurred while editing the message",
        event.editConversationRequest.conversationId.toString(),
      ),
    );
    return false;
  }
}

// Handles the editing conversation event
_editingConversationEventHandler(LMChatEditingConversationEvent event,
    Emitter<LMChatConversationActionState> emit) async {
  emit(LMChatEditRemoveState());
  emit(
    LMChatEditConversationState(
      chatroomId: event.chatroomId,
      conversationId: event.conversationId,
      editConversation: event.editConversation,
    ),
  );
}

// Handles the remove edit event
_editRemoveEventHandler(
    LMChatEditRemoveEvent event, Emitter<LMChatConversationActionState> emit) async {
  emit(LMChatEditRemoveState());
}
