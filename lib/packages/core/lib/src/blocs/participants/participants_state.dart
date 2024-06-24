part of 'participants_bloc.dart';

/// abstract class [LMChatParticipantsState] is used to define the state of the participants bloc.
abstract class LMChatParticipantsState extends Equatable {
  const LMChatParticipantsState();

  @override
  List<Object> get props => [];
}

/// [LMChatParticipantsInitialState] is the initial state of the participants bloc.
class LMChatParticipantsInitialState extends LMChatParticipantsState {
  const LMChatParticipantsInitialState();
}

/// [LMChatParticipantsLoadingState] is the state when the participants are being loading.
class LMChatParticipantsLoadingState extends LMChatParticipantsState {
  const LMChatParticipantsLoadingState();
}

/// [LMChatParticipantsPaginationLoading] is the state when the participants data loaded.
class LMChatParticipantsLoadedState extends LMChatParticipantsState {
  final List<LMChatUserViewData> participants;
  final int page;

  const LMChatParticipantsLoadedState({required this.participants, required this.page});
  @override
  List<Object> get props => [participants];
}

/// [LMChatParticipantsErrorState] is the state when an error occurs while loading participants.
class LMChatParticipantsErrorState extends LMChatParticipantsState {
  final String errorMessage;

  const LMChatParticipantsErrorState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
