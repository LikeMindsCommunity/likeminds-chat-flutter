part of '../member_list_bloc.dart';

/// Function to handle fetch all members events,
/// emits appropriate state based on response,
/// and converts models to view data models
void _getAllMembersEventHandler(
  LMChatGetAllMemberEvent event,
  Emitter<LMChatMemberListState> emit,
) async {
  try {
    emit(LMChatMemberListLoading());

    final request = (GetAllMembersRequestBuilder()
          ..page(event.page)
          ..filterMemberRoles([UserRole.member, UserRole.admin])
          ..excludeSelfUser(true))
        .build();
    debugPrint('GetAllMembersRequest: $request');
    final response = await LMChatCore.client.getAllMembers(request);

    if (!response.success) {
      emit(LMChatMemberListError(
        message: response.errorMessage ?? 'Failed to fetch members',
      ));
      return;
    }

    final members = response.data?.members
            ?.map((member) => member.toUserViewData())
            .toList() ??
        [];

    emit(LMChatMemberListLoaded(
      members: members,
      totalMembers: response.data?.totalMembers ?? 0,
      page: event.page,
    ));
  } catch (e) {
    emit(LMChatMemberListError(
      message: e.toString(),
    ));
  }
} 