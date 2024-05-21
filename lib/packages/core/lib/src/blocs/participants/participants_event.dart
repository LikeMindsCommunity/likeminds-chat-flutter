part of 'participants_bloc.dart';

abstract class LMChatParticipantsEvent extends Equatable {
  const LMChatParticipantsEvent();

  @override
  List<Object> get props => [];
}

class LMChatGetParticipantsEvent extends LMChatParticipantsEvent {
  final GetParticipantsRequest getParticipantsRequest;

  const LMChatGetParticipantsEvent({required this.getParticipantsRequest});

  @override
  List<Object> get props => [getParticipantsRequest.toJson()];
}
