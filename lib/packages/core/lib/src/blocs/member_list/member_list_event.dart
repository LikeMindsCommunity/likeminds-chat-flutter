part of 'member_list_bloc.dart';

@immutable
sealed class LMChatMemberListEvent extends Equatable {
  const LMChatMemberListEvent();

  @override
  List<Object?> get props => [];
}

class LMChatMemberListFetchEvent extends LMChatMemberListEvent {}

class LMChatMemberListFetchMoreEvent extends LMChatMemberListEvent {}

class LMChatMemberListSearchEvent extends LMChatMemberListEvent {
  final String query;
  const LMChatMemberListSearchEvent({required this.query});
}


