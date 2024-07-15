part of 'explore_bloc.dart';

/// Abstract class to represent an explore event
abstract class LMChatExploreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event class to fetch Explore feed
class LMChatFetchExploreEvent extends LMChatExploreEvent {
  final GetExploreFeedRequest getExploreFeedRequest;

  LMChatFetchExploreEvent({required this.getExploreFeedRequest});

  @override
  List<Object> get props => [getExploreFeedRequest.toJson()];
}

/// Event class to refresh Explore feed
class LMChatRefreshExploreEvent extends LMChatExploreEvent {
  final int orderType;
  final bool pinned;

  LMChatRefreshExploreEvent({
    required this.orderType,
    required this.pinned,
  });
}

/// Event class to pin an Explore space to feed
class LMChatPinSpaceEvent extends LMChatExploreEvent {
  final String spaceId;
  final bool isPinned;

  LMChatPinSpaceEvent(this.spaceId, this.isPinned);

  @override
  List<Object> get props => [spaceId, isPinned];
}
