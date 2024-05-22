part of 'conversation_bloc.dart';

abstract class LMChatConversationState extends Equatable {}

class ConversationInitial extends LMChatConversationState {
  @override
  List<Object> get props => [];
}

class ConversationLoading extends LMChatConversationState {
  @override
  List<Object> get props => [];
}

class ConversationPaginationLoading extends LMChatConversationState {
  @override
  List<Object> get props => [];
}

class ConversationLoaded extends LMChatConversationState {
  final GetConversationResponse getConversationResponse;

  ConversationLoaded(this.getConversationResponse);

  @override
  List<Object> get props => [getConversationResponse];
}

class ConversationError extends LMChatConversationState {
  final String message;
  final String temporaryId;

  ConversationError(
    this.message,
    this.temporaryId,
  );

  @override
  List<Object> get props => [message];
}

class ConversationUpdated extends LMChatConversationState {
  final Conversation response;

  ConversationUpdated({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class LocalConversation extends LMChatConversationState {
  final Conversation conversation;

  LocalConversation(this.conversation);

  @override
  List<Object> get props => [
        conversation,
      ];
}

class ConversationPosted extends LMChatConversationState {
  final PostConversationResponse postConversationResponse;

  ConversationPosted(
    this.postConversationResponse,
  );

  @override
  List<Object> get props => [
        postConversationResponse,
      ];
}

class MultiMediaConversationLoading extends LMChatConversationState {
  final Conversation postConversation;
  final List<LMChatMedia> mediaFiles;

  MultiMediaConversationLoading(
    this.postConversation,
    this.mediaFiles,
  );

  @override
  List<Object> get props => [
        mediaFiles,
      ];
}

class MultiMediaConversationPosted extends LMChatConversationState {
  final PostConversationResponse postConversationResponse;
  final List<LMChatMedia> putMediaResponse;

  MultiMediaConversationPosted(
    this.postConversationResponse,
    this.putMediaResponse,
  );

  @override
  List<Object> get props => [
        postConversationResponse,
        putMediaResponse,
      ];
}

class MultiMediaConversationError extends LMChatConversationState {
  final String errorMessage;
  final String temporaryId;

  MultiMediaConversationError(
    this.errorMessage,
    this.temporaryId,
  );

  @override
  List<Object> get props => [
        errorMessage,
        temporaryId,
      ];
}
