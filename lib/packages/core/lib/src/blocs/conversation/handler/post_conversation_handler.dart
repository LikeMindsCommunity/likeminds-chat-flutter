part of '../conversation_bloc.dart';

mapPostConversationFunction(
  PostConversation event,
  Emitter<LMChatConversationState> emit,
) async {
  try {
    DateTime dateTime = DateTime.now();
    User user = LMChatPreferences.instance.getUser()!;
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
    emit(LocalConversation(conversation));
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
      emit(ConversationPosted(response.data!));

      return false;
    } else {
      emit(ConversationError(
        response.errorMessage!,
        event.postConversationRequest.temporaryId,
      ));
      return false;
    }
  } catch (e) {
    emit(ConversationError(
      "An error occurred",
      event.postConversationRequest.temporaryId,
    ));
    return false;
  }
}
