part of 'conversation_bloc.dart';

abstract class ConversationState extends Equatable {}

class ConversationInitial extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationLoading extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationPaginationLoading extends ConversationState {
  @override
  List<Object> get props => [];
}

class ConversationLoaded extends ConversationState {
  final GetConversationResponse getConversationResponse;

  ConversationLoaded(this.getConversationResponse);

  @override
  List<Object> get props => [getConversationResponse];
}

class ConversationError extends ConversationState {
  final String message;
  final String temporaryId;

  ConversationError(
    this.message,
    this.temporaryId,
  );

  @override
  List<Object> get props => [message];
}

class ConversationUpdated extends ConversationState {
  final Conversation response;

  ConversationUpdated({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class LocalConversation extends ConversationState {
  final Conversation conversation;

  LocalConversation(this.conversation);

  @override
  List<Object> get props => [
        conversation,
      ];
}

class ConversationPosted extends ConversationState {
  final PostConversationResponse postConversationResponse;

  ConversationPosted(
    this.postConversationResponse,
  );

  @override
  List<Object> get props => [
        postConversationResponse,
      ];
}

class MultiMediaConversationLoading extends ConversationState {
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

class MultiMediaConversationPosted extends ConversationState {
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

class MultiMediaConversationError extends ConversationState {
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
