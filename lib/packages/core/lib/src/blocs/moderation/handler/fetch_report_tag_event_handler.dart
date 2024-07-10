part of "../moderation_bloc.dart";
// Event handler function to fetch report tags
void _fetchTagsEventHandler(LMChatModerationFetchTagsEvent event, emit) async {
  emit(LMChatModerationTagLoadingState());
  final GetReportTagRequest reportTagRequest =
      (GetReportTagRequestBuilder()..type(3)).build();
  final LMResponse<GetReportTagResponse> response =
      await LMChatCore.instance.lmChatClient.getReportTags(
    reportTagRequest,
  );
  if (response.success && response.data != null) {
    final tags = response.data!.reportTags;
    final List<LMChatReportTagViewData> reportTag =
        tags?.map((tag) => tag.toReportTagViewData()).toList() ?? [];
    emit(
      LMChatModerationTagLoadedState(tags: reportTag),
    );
  } else {
    emit(
      LMChatModerationTagLoadingErrorState(
        message: response.errorMessage!,
      ),
    );
  }
}
