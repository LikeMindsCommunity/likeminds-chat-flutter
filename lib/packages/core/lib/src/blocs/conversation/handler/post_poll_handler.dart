part of '../conversation_bloc.dart';

/// Handler for posting a poll conversation
void postPollConversationHandler(
    LMChatPostPollConversationEvent event, emit) async {
  emit(LMChatConversationLoadingState());
  User user = LMChatLocalPreference.instance.getUser();
  // map poll options
  final pollOptions =
      event.polls.map((option) => PollOption(text: option)).toList();
  // create request builder
  final PostPollConversationRequestBuilder requestBuilder =
      PostPollConversationRequestBuilder()
        ..chatroomId(event.chatroomId)
        ..text(event.text)
        ..state(10)
        ..polls(pollOptions)
        ..pollType(event.pollType)
        ..multipleSelectState(event.multipleSelectState)
        ..multipleSelectNo(event.multipleSelectNo)
        ..isAnonymous(event.isAnonymous)
        ..allowAddOption(event.allowAddOption)
        ..expiryTime(event.expiryTime)
        ..temporaryId(event.temporaryId);
  if (event.repliedConversationId != null) {
    requestBuilder.repliedConversationId(event.repliedConversationId!);
  }
  // create request object
  final PostPollConversationRequest pollRequest = requestBuilder.build();

  final DateTime dateTime = DateTime.now();
  // create local conversation
  LMChatConversationViewData conversationViewData =
      (LMChatConversationViewDataBuilder()
            ..allowAddOption(event.allowAddOption)
            ..answer(event.text)
            ..chatroomId(event.chatroomId)
            ..createdAt("")
            ..expiryTime(event.expiryTime)
            ..memberId(user.id)
            ..member(user.toUserViewData())
            ..multipleSelectNo(event.multipleSelectNo)
            ..multipleSelectState(
                LMChatPollMultiSelectState.fromValue(event.multipleSelectState))
            ..date("${dateTime.day} ${dateTime.month} ${dateTime.year}")
            ..state(10)
            ..poll(pollOptions.map((e) => e.toPollOptionViewData()).toList())
            ..pollType(LMChatPollType.fromValue(event.pollType))
            ..member(user.toUserViewData())
            ..temporaryId(event.temporaryId)
            ..id(int.parse(event.temporaryId))
            ..submitTypeText(
                event.isAnonymous ? "Secret voting " : "Public voting"))
          .build();
  emit(LMChatLocalConversationState(conversationViewData));
// post conversation to server
  LMResponse<PostConversationResponse> response =
      await LMChatCore.client.postPollConversation(pollRequest);
  if (response.success && response.data != null) {
    // update local conversation with server response
    Conversation conversation = response.data!.conversation!;
    conversationViewData = conversation.toConversationViewData();
    emit(LMChatConversationPostedState(conversationViewData));
  } else {
    emit(LMChatConversationErrorState(
      response.errorMessage!,
      pollRequest.temporaryId,
    ));
  }
}
