part of 'home_bloc.dart';

/// Base event class for [LMChatHomeFeedBloc]
/// Tracks events related to DM home feed
@immutable
sealed class LMChatHomeFeedEvent extends Equatable {}

/// Event class for fetching Home feed.
/// Requires a page size [int]
class LMChatFetchHomeFeedEvent extends LMChatHomeFeedEvent {
  final int page;

  LMChatFetchHomeFeedEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

/// Event class for refreshing Home feed
/// in cases of realtime update, or changing states
class LMChatRefreshHomeFeedEvent extends LMChatHomeFeedEvent {
  @override
  List<Object?> get props => [];
}
