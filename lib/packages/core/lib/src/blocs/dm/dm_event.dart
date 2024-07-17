part of 'dm_bloc.dart';

/// Base event class for [LMChatDMFeedBloc]
/// Tracks events related to DM home feed
@immutable
sealed class LMChatDMFeedEvent extends Equatable {}

/// Event class for fetching DM feed.
/// Requires a page size [int]
class LMChatFetchDMFeedEvent extends LMChatDMFeedEvent {
  final int page;

  LMChatFetchDMFeedEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

/// Event class for refreshing DM feed
/// in cases of realtime update, or changing states
class LMChatRefreshDMFeedEvent extends LMChatDMFeedEvent {
  @override
  List<Object?> get props => [];
}
