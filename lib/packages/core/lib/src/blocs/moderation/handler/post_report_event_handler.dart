part of "../moderation_bloc.dart";

/// Event handler function to post report
void _postReportEventHandler(
    LMChatModerationPostReportEvent event, emit) async {
  final PostReportRequestBuilder postConversationRequestBuilder =
      PostReportRequestBuilder()
        ..entityId(event.entityId)
        ..tagId(event.reportTagId)
        ..reason(event.reason);

  final LMResponse<void> response =
      await LMChatCore.instance.lmChatClient.postReport(
    postConversationRequestBuilder.build(),
  );
  if (response.success) {
    emit(LMChatModerationReportPostedState());
  } else {
    emit(
      LMChatModerationTagLoadingErrorState(
        message: response.errorMessage!,
      ),
    );
  }
}
