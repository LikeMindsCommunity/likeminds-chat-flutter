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
            ..allowAddOption(pollRequest.allowAddOption)
            ..answer(pollRequest.text)
            ..chatroomId(pollRequest.chatroomId)
            ..createdAt("")
            ..expiryTime(pollRequest.expiryTime)
            ..memberId(user.id)
            ..member(user.toUserViewData())
            ..multipleSelectNo(pollRequest.multipleSelectNo)
            ..multipleSelectState(LMChatPollMultiSelectState.fromValue(
                pollRequest.multipleSelectState))
            ..date("${dateTime.day} ${dateTime.month} ${dateTime.year}")
            ..state(10)
            ..poll(event.postPollConversationRequest.polls
                .map((e) => e.toPollOptionViewData())
                .toList())
            ..pollType(LMChatPollType.fromValue(pollRequest.pollType))
            ..member(user.toUserViewData())
            ..temporaryId(pollRequest.temporaryId)
            ..id(int.parse(pollRequest.temporaryId))
            ..submitTypeText(
                pollRequest.isAnonymous ? "Secret voting " : "Public voting"))
          .build();
  emit(LMChatLocalConversationState(conversationViewData));

  LMResponse<PostConversationResponse> response = await LMChatCore.client
      .postPollConversation(event.postPollConversationRequest);
  if (response.success && response.data != null) {
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
