part of 'member_list_bloc.dart';

@immutable
sealed class LMChatMemberListState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LmChatMemberListInitial extends LMChatMemberListState {}

final class LMChatMemberListLoading extends LMChatMemberListState {}

final class LMChatMemberListLoaded extends LMChatMemberListState {
  final List<LMChatUserViewData> members;
  final int totalMembers;
  final int page;

  LMChatMemberListLoaded({
    required this.members,
    required this.totalMembers,
    required this.page,
  });

  @override
  List<Object?> get props => [members, totalMembers, page];
}

final class LMChatMemberListError extends LMChatMemberListState {
  final String message;

  LMChatMemberListError({required this.message});

  @override
  List<Object?> get props => [message];
}
