part of 'home_bloc.dart';

@immutable
abstract class LMChatHomeState {}

class LMChatHomeInitial extends LMChatHomeState {}

class LMChatHomeLoading extends LMChatHomeState {}

class LMChatHomeLoaded extends LMChatHomeState {
  // final List<ChatItem> chats;
  final GetHomeFeedResponse response;

  LMChatHomeLoaded({required this.response});
}

class LMChatUpdateHomeFeed extends LMChatHomeState {
  final GetHomeFeedResponse response;

  LMChatUpdateHomeFeed({required this.response});
}

class LMChatUpdatedHomeFeed extends LMChatHomeState {}

class LMChatRealTimeHomeUpdate extends LMChatHomeState {
  final int chatroomId;
  final int conversationId;

  LMChatRealTimeHomeUpdate(
      {required this.chatroomId, required this.conversationId});
}

class LMChatHomeError extends LMChatHomeState {
  final String message;

  LMChatHomeError(this.message);
}
