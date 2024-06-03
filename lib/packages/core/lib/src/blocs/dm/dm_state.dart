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
  final List<ChatRoom> chatrooms;
  final Map<String, Conversation> conversationMeta;
  final Map<int, User> userMeta;

  LMChatDMFeedLoaded({
    required this.chatrooms,
    required this.conversationMeta,
    required this.userMeta,
  });
}

/// State class to represent updated state of DM home feed.
class LMChatDMFeedUpdated extends LMChatDMFeedState {
  final List<ChatRoom> chatrooms;
  final Map<String, Conversation>? conversationMeta;
  final Map<int, User>? userMeta;

  LMChatDMFeedUpdated({
    required this.chatrooms,
    required this.conversationMeta,
    required this.userMeta,
  });
}

/// State class to represent error state of DM home feed.
class LMChatDMFeedError extends LMChatDMFeedState {
  final String errorMessage;

  LMChatDMFeedError({required this.errorMessage});
}
