part of 'explore_bloc.dart';

/// Abstract class to represent a state for LMChat Explore feed
abstract class LMChatExploreState {}

class LMChatExploreInitialState extends LMChatExploreState {}

class LMChatExploreLoadingState extends LMChatExploreState {}

class LMChatExploreErrorState extends LMChatExploreState {
  final String errorMessage;

  LMChatExploreErrorState(this.errorMessage);
}

class LMChatExploreLoadedState extends LMChatExploreState {
  final GetExploreFeedResponse getExploreFeedResponse;

  LMChatExploreLoadedState(this.getExploreFeedResponse);
}
