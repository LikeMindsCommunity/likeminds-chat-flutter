part of '../conversation_bloc.dart';

/// Handler for posting a poll conversation
void postPollConversationHandler(
    LMChatPostPollConversationEvent event, emit) async {
  emit(LMChatConversationLoadingState());

  User user = LMChatLocalPreference.instance.getUser();
  final PostPollConversationRequest pollRequest =
      event.postPollConversationRequest;
  final DateTime dateTime = DateTime.now();
  LMChatConversationViewData conversationViewData =
      (LMChatConversationViewDataBuilder()
            ..answer(pollRequest.text)
            ..chatroomId(pollRequest.chatroomId)
            ..createdAt("")
            ..memberId(user.id)
            ..header("")
            ..date("${dateTime.day} ${dateTime.month} ${dateTime.year}")
            ..state(10)
            ..poll(event.postPollConversationRequest.polls
                .map((e) => e.toPollOptionViewData())
                .toList())
            // ..replyId(pollRequest.repliedConversationId?? )
            // ..attachmentCount(event.attachmentCount)
            // ..replyConversationObject(event.repliedTo)
            // ..hasFiles(event.hasFiles)
            ..member(user.toUserViewData())
            ..temporaryId(pollRequest.temporaryId)
            ..id(1))
          .build();
  emit(LMChatLocalConversationState(conversationViewData));

  LMResponse<PostConversationResponse> response = await LMChatCore.client
      .postPollConversation(event.postPollConversationRequest);
  if (response.success && response.data != null) {
    Conversation conversation = response.data!.conversation!;
    conversationViewData = conversation.toConversationViewData();
    // if (conversation.replyId != null ||
    //     conversation.replyConversation != null) {
    //   conversationViewData = conversationViewData.copyWith(
    //     replyConversationObject: event.repliedTo,
    //   );
    // }
    emit(LMChatConversationPostedState(conversationViewData));

    LMChatConversationBloc.instance.lastConversationId = conversation.id;
  } else {
    emit(LMChatConversationErrorState(
      response.errorMessage!,
      pollRequest.temporaryId,
    ));
  }
}
