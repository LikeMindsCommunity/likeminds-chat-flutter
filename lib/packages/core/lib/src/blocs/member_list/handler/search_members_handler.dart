part of '../member_list_bloc.dart';

/// Function to handle search members events,
/// emits appropriate state based on response,
/// and converts models to view data models
void _searchMembersEventHandler(
  LMChatMemberListSearchEvent event,
  Emitter<LMChatMemberListState> emit,
) async {
  try {
    emit(LMChatMemberListLoading());

    final memberStates = event.showList == 1 ? [1, 4] : [1];

    final request = (SearchMemberRequestBuilder()
          ..page(event.page)
          ..memberStates(memberStates)
          ..excludeSelfUser(true)
          ..searchType('name')
          ..search(event.query))
        .build();
    debugPrint('SearchMembersRequest: $request');
    final response = await LMChatCore.client.searchMembers(request);

    if (!response.success) {
      emit(LMChatMemberListError(
        message: response.errorMessage ?? 'Failed to search members',
      ));
      return;
    }

    final members = response.data?.members
            ?.map((member) => member.toUserViewData())
            .toList() ??
        [];

    emit(LMChatMemberListLoaded(
      members: members,
      totalMembers: response.data?.members?.length ?? 0,
      page: event.page,
    ));
  } catch (e) {
    emit(LMChatMemberListError(
      message: e.toString(),
    ));
  }
}
