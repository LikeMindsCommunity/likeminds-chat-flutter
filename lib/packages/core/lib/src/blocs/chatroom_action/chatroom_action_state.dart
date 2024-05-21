part of 'chatroom_action_bloc.dart';

@immutable
abstract class ChatroomActionState extends Equatable {}

class ChatroomActionInitial extends ChatroomActionState {
  @override
  List<Object?> get props => [];
}

class ChatroomActionLoading extends ChatroomActionState {
  @override
  List<Object?> get props => [];
}

class ChatroomTopicSet extends ChatroomActionState {
  final Conversation topic;
  ChatroomTopicSet(this.topic);
  @override
  List<Object?> get props => [topic];
}

class ChatroomTopicError extends ChatroomActionState {
  final String errorMessage;
  ChatroomTopicError({
    required this.errorMessage,
  });
  @override
  List<Object?> get props => [errorMessage];
}
