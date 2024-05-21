part of 'chatroom_bloc.dart';

@immutable
abstract class LMChatroomState extends Equatable {}

class LMChatroomInitialState extends LMChatroomState {
  @override
  List<Object> get props => [];
}

class LMChatroomLoadingState extends LMChatroomState {
  @override
  List<Object> get props => [];
}

class LMChatroomLoadedState extends LMChatroomState {
  final GetChatroomResponse getChatroomResponse;

  LMChatroomLoadedState({required this.getChatroomResponse});

  @override
  List<Object> get props => [getChatroomResponse];
}

class LMChatroomErrorState extends LMChatroomState {
  final String message;

  LMChatroomErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class LMChatroomReportState extends LMChatroomState {
  final String message;

  LMChatroomReportState(this.message);

  @override
  List<Object> get props => [message];
}
