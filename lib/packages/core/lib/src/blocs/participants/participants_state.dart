part of 'participants_bloc.dart';

/// abstract class [LMChatParticipantsState] is used to define the state of the participants bloc.
abstract class LMChatParticipantsState extends Equatable {
  /// [LMChatParticipantsState] constructor to create an instance of [LMChatParticipantsState].
  const LMChatParticipantsState();

  @override
  List<Object> get props => [];
}

/// [LMChatParticipantsInitialState] is the initial state of the participants bloc.
class LMChatParticipantsInitialState extends LMChatParticipantsState {
  /// [LMChatParticipantsInitialState] constructor to create an instance of [LMChatParticipantsInitialState].
  const LMChatParticipantsInitialState();
}

/// [LMChatParticipantsLoadingState] is the state when the participants are being loading.
class LMChatParticipantsLoadingState extends LMChatParticipantsState {
  /// [LMChatParticipantsLoadingState] constructor to create an instance of [LMChatParticipantsLoadingState].
  const LMChatParticipantsLoadingState();
}

/// [LMChatParticipantsPaginationLoading] is the state when the participants data loaded.
class LMChatParticipantsLoadedState extends LMChatParticipantsState {
  /// [participants] is the list of participants.
  final List<LMChatUserViewData> participants;

  /// [page] is the current page for pagination.
  final int page;

  /// [LMChatParticipantsLoadedState] constructor to create an instance of [LMChatParticipantsLoadedState].
  const LMChatParticipantsLoadedState({
    required this.participants,
    required this.page,
  });
  @override
  List<Object> get props => [participants];
}

/// [LMChatParticipantsErrorState] is the state when an error occurs while loading participants.
class LMChatParticipantsErrorState extends LMChatParticipantsState {
  /// [errorMessage] is the error message.
  final String errorMessage;

  /// [LMChatParticipantsErrorState] constructor to create an instance of [LMChatParticipantsErrorState].
  const LMChatParticipantsErrorState({
    required this.errorMessage,
  });
  @override
  List<Object> get props => [errorMessage];
}

/// New state to indicate searching
class LMChatParticipantsSearchingState extends LMChatParticipantsState {
  const LMChatParticipantsSearchingState();
}
