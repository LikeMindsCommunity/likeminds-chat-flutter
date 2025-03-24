part of 'member_list_bloc.dart';

@immutable
sealed class LMChatMemberListEvent extends Equatable {
  const LMChatMemberListEvent();

  @override
  List<Object?> get props => [];
}

class LMChatGetAllMemberEvent extends LMChatMemberListEvent {
  final int page;
  final int pageSize;

  const LMChatGetAllMemberEvent({
    required this.page,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [page, pageSize];
}


class LMChatMemberListSearchEvent extends LMChatMemberListEvent {
  final String query;
  final int page;
  final int pageSize;
  const LMChatMemberListSearchEvent({
    required this.query,
    required this.page,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [query, page, pageSize];
}
