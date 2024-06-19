part of 'home_bloc.dart';

/// Base state class for [LMChatDMFeedBloc]
/// Tracks all states related to DM home feed
@immutable
sealed class LMChatHomeFeedState {}

/// State class to represent initial state of DM home feed.
class LMChatHomeInitial extends LMChatHomeFeedState {}

/// State class to represent loading state of DM home feed.
class LMChatHomeFeedLoading extends LMChatHomeFeedState {}

/// State class to represent loaded state of DM home feed.
class LMChatHomeFeedLoaded extends LMChatHomeFeedState {
  final List<LMChatRoomViewData> chatrooms;

  LMChatHomeFeedLoaded({
    required this.chatrooms,
  });
}

/// State class to represent updated state of DM home feed.
class LMChatHomeFeedUpdated extends LMChatHomeFeedState {
  final List<LMChatRoomViewData> chatrooms;

  LMChatHomeFeedUpdated({
    required this.chatrooms,
  });
}

/// State class to represent error state of DM home feed.
class LMChatHomeFeedError extends LMChatHomeFeedState {
  final String errorMessage;

  LMChatHomeFeedError({required this.errorMessage});
}
