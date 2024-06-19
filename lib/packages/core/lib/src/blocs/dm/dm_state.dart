part of 'dm_bloc.dart';

/// Base state class for [LMChatDMFeedBloc]
/// Tracks all states related to DM home feed
@immutable
sealed class LMChatDMFeedState {}

/// State class to represent initial state of DM home feed.
class LMChatDMInitial extends LMChatDMFeedState {}

/// State class to represent loading state of DM home feed.
class LMChatDMFeedLoading extends LMChatDMFeedState {}

/// State class to represent loaded state of DM home feed.
class LMChatDMFeedLoaded extends LMChatDMFeedState {
  final List<LMChatRoomViewData> chatrooms;

  LMChatDMFeedLoaded({
    required this.chatrooms,
  });
}

/// State class to represent updated state of DM home feed.
class LMChatDMFeedUpdated extends LMChatDMFeedState {
  final List<LMChatRoomViewData> chatrooms;

  LMChatDMFeedUpdated({
    required this.chatrooms,
  });
}

/// State class to represent error state of DM home feed.
class LMChatDMFeedError extends LMChatDMFeedState {
  final String errorMessage;

  LMChatDMFeedError({required this.errorMessage});
}
