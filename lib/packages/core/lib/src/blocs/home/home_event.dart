part of 'home_bloc.dart';

/// Base event class for [LMChatHomeFeedBloc]
/// Tracks events related to DM home feed
@immutable
sealed class LMChatHomeFeedEvent extends Equatable {}

/// {@template lm_chat_home_feed_event}
/// Event class for fetching Home feed.
/// Requires a page size [int]
/// {@endtemplate}
class LMChatFetchHomeFeedEvent extends LMChatHomeFeedEvent {
  /// the page index to fetch chatrooms for
  final int page;

  /// custom tags for which chatrooms need to be fetched
  final String? tag;

  ///{@macro lm_chat_home_feed_event}
  LMChatFetchHomeFeedEvent({
    required this.page,
    this.tag,
  });

  @override
  List<Object?> get props => [page];
}

///{@template lm_chat_refresh_home_feed_event}
/// Event class for refreshing Home feed
/// in cases of realtime update, or changing states
/// {@endtemplate}
class LMChatRefreshHomeFeedEvent extends LMChatHomeFeedEvent {
  /// custom tags for which chatrooms need to be fetched
  final String? tag;

  ///{@macro lm_chat_refresh_home_feed_event}
  LMChatRefreshHomeFeedEvent({this.tag});

  @override
  List<Object?> get props => [];
}
