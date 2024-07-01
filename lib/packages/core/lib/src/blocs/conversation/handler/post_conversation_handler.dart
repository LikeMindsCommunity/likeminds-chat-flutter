part of '../conversation_bloc.dart';

/// Handler for managing post conversation event
postConversationEventHandler(
  LMChatPostConversationEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  try {
    DateTime dateTime = DateTime.now();
    User user = LMChatLocalPreference.instance.getUser();
    Conversation conversation = Conversation(
      answer: event.postConversationRequest.text,
      chatroomId: event.postConversationRequest.chatroomId,
      createdAt: "",
      userId: user.id,
      header: "",
      date: "${dateTime.day} ${dateTime.month} ${dateTime.year}",
      replyId: event.postConversationRequest.replyId,
      attachmentCount: event.postConversationRequest.attachmentCount,
      replyConversationObject: event.repliedTo,
      hasFiles: event.postConversationRequest.hasFiles,
      member: user,
      temporaryId: event.postConversationRequest.temporaryId,
      id: 1,
    );
    emit(LMChatLocalConversationState(conversation));
    LMResponse<PostConversationResponse> response =
        await LMChatCore.client.postConversation(
      event.postConversationRequest,
    );

    if (response.success) {
      Conversation conversation = response.data!.conversation!;
      if (conversation.replyId != null ||
          conversation.replyConversation != null) {
        conversation.replyConversationObject = event.repliedTo;
      }
      emit(LMChatConversationPostedState(response.data!));

      return false;
    } else {
      emit(LMChatConversationErrorState(
        response.errorMessage!,
        event.postConversationRequest.temporaryId,
      ));
      return false;
    }
  } catch (e) {
    emit(LMChatConversationErrorState(
      "An error occurred",
      event.postConversationRequest.temporaryId,
    ));
    return false;
  }
}
