part of 'participants_bloc.dart';

abstract class LMChatParticipantsState extends Equatable {
  const LMChatParticipantsState();

  @override
  List<Object> get props => [];
}

class LMChatParticipantsInitial extends LMChatParticipantsState {
  const LMChatParticipantsInitial();
}

class LMChatParticipantsLoading extends LMChatParticipantsState {
  const LMChatParticipantsLoading();
}

class LMChatParticipantsPaginationLoading extends LMChatParticipantsState {
  const LMChatParticipantsPaginationLoading();
}

class LMChatParticipantsLoaded extends LMChatParticipantsState {
  final GetParticipantsResponse getParticipantsResponse;

  const LMChatParticipantsLoaded({required this.getParticipantsResponse});
}

class LMChatParticipantsError extends LMChatParticipantsState {
  final String message;

  const LMChatParticipantsError(this.message);
}
