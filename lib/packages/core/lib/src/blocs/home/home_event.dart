part of 'home_bloc.dart';

@immutable
abstract class LMChatHomeEvent extends Equatable {}

class LMChatInitHomeEvent extends LMChatHomeEvent {
  final GetHomeFeedRequest request;

  LMChatInitHomeEvent({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class LMChatGetHomeFeedEvent extends LMChatHomeEvent {
  final GetHomeFeedRequest request;

  LMChatGetHomeFeedEvent({
    required this.request,
  });
  @override
  List<Object?> get props => [];
}

class LMChatReloadHomeEvent extends LMChatHomeEvent {
  final GetHomeFeedResponse response;

  LMChatReloadHomeEvent({required this.response});
  @override
  List<Object?> get props => [response];
}

class LMChatUpdateHomeEvent extends LMChatHomeEvent {
  final GetHomeFeedRequest? request;

  LMChatUpdateHomeEvent({
    this.request,
  });

  @override
  List<Object?> get props => [];
}
