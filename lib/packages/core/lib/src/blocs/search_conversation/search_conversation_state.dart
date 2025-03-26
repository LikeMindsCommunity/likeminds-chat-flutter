part of 'search_conversation_bloc.dart';

/// Abstract class [LMChatSearchConversationState] is used to define the state of the search conversation bloc.
sealed class LMChatSearchConversationState extends Equatable {
  /// [LMChatSearchConversationState] constructor to create an instance of [LMChatSearchConversationState].
  const LMChatSearchConversationState();

  @override
  List<Object> get props => [];
}

/// [LMChatSearchConversationInitial] is the initial state of the search conversation bloc.
class LMChatSearchConversationInitial extends LMChatSearchConversationState {
  /// [LMChatSearchConversationInitial] constructor to create an instance of [LMChatSearchConversationInitial].
  const LMChatSearchConversationInitial();
}

/// [LMChatSearchConversationLoadingState] is the state when the search results are being loaded.
class LMChatSearchConversationLoadingState
    extends LMChatSearchConversationState {
  /// [LMChatSearchConversationLoadingState] constructor to create an instance of [LMChatSearchConversationLoadingState].
  const LMChatSearchConversationLoadingState();
}

/// [LMChatSearchConversationLoadedState] is the state when the search results are successfully loaded.
class LMChatSearchConversationLoadedState
    extends LMChatSearchConversationState {
  /// [results] is the list of search results.
  final List<LMChatConversationViewData> results;

  /// [page] is the current page for pagination.
  final int page;

  /// [LMChatSearchConversationLoadedState] constructor to create an instance of [LMChatSearchConversationLoadedState].
  const LMChatSearchConversationLoadedState({
    required this.results,
    required this.page,
  });

  @override
  List<Object> get props => [results, page];
}

/// [LMChatSearchConversationErrorState] is the state when an error occurs while loading search results.
class LMChatSearchConversationErrorState extends LMChatSearchConversationState {
  /// [errorMessage] is the error message.
  final String errorMessage;

  /// [LMChatSearchConversationErrorState] constructor to create an instance of [LMChatSearchConversationErrorState].
  const LMChatSearchConversationErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

/// [LMChatSearchConversationPaginationLoadingState] is the state when the search results are being loaded for pagination.
class LMChatSearchConversationPaginationLoadingState
    extends LMChatSearchConversationState {
  const LMChatSearchConversationPaginationLoadingState();
}
