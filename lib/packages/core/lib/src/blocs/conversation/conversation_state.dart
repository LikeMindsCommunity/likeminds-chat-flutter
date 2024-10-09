part of 'conversation_bloc.dart';

/// Abtract class representing a LMChat conversation state
abstract class LMChatConversationState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Represents the initial state of a conversation.
class LMChatConversationInitialState extends LMChatConversationState {}

/// Represents the loading state of a conversation.
class LMChatConversationLoadingState extends LMChatConversationState {}

/// Represents the loaded state of a conversation.
class LMChatConversationLoadedState extends LMChatConversationState {
  /// The response containing the loaded conversation data.
  final GetConversationResponse getConversationResponse;

  final PaginationDirection direction;

  /// Creates and returns a new instance of [LMChatConversationLoadedState]
  LMChatConversationLoadedState(this.getConversationResponse, this.direction);

  @override
  List<Object> get props => [getConversationResponse, direction];
}

/// Represents an error state in the conversation.
class LMChatConversationErrorState extends LMChatConversationState {
  /// The error message.
  final String message;

  /// A temporary identifier associated with the error.
  final String temporaryId;

  /// Creates and returns a new instance of [LMChatConversationErrorState]
  LMChatConversationErrorState(
    this.message,
    this.temporaryId,
  );

  @override
  List<Object> get props => [message];
}

/// Represents an updated state of the conversation.
class LMChatConversationUpdatedState extends LMChatConversationState {
  /// The updated conversation data.
  final LMChatConversationViewData conversationViewData;

  final Map<String, List<LMChatAttachmentViewData>> attachments;

  /// check if the conversation should be updated explicitly
  /// irrespective of the last conversation id
  /// This is useful when editing a poll
  final bool shouldUpdate;

  /// Creates and returns a new instance of [LMChatConversationUpdatedState]
  LMChatConversationUpdatedState({
    required this.conversationViewData,
    required this.attachments,
    this.shouldUpdate = false,
  });

  @override
  List<Object> get props => [
        conversationViewData,
        attachments,
        shouldUpdate,
      ];
}

/// Represents a local state of the conversation.
class LMChatLocalConversationState extends LMChatConversationState {
  /// The local conversation data.
  final LMChatConversationViewData conversationViewData;

  /// Creates and returns a new instance of [LMChatLocalConversationState]
  LMChatLocalConversationState(this.conversationViewData);

  @override
  List<Object> get props => [conversationViewData];
}

/// Represents the state after a conversation has been posted.
class LMChatConversationPostedState extends LMChatConversationState {
  /// The response received after posting the conversation.
  final LMChatConversationViewData conversationViewData;

  /// Creates and returns a new instance of [LMChatConversationPostedState]
  LMChatConversationPostedState(
    this.conversationViewData,
  );

  @override
  List<Object> get props => [
        conversationViewData,
      ];
}

/// Represents the loading state for a multimedia conversation.
class LMChatMultiMediaConversationLoadingState extends LMChatConversationState {
  /// The conversation being posted.
  final Conversation postConversation;

  /// The list of media files associated with the conversation.
  final List<LMChatMediaModel> mediaFiles;

  /// Creates and returns a new instance of [LMChatMultiMediaConversationLoadingState]
  LMChatMultiMediaConversationLoadingState(
    this.postConversation,
    this.mediaFiles,
  );

  @override
  List<Object> get props => [mediaFiles, postConversation];
}

/// Represents the state after a multimedia conversation has been posted.
class LMChatMultiMediaConversationPostedState extends LMChatConversationState {
  /// The response received after posting the conversation.
  final PostConversationResponse postConversationResponse;

  /// The response received after putting (uploading) the media files.
  final List<LMChatMediaModel> putMediaResponse;

  /// Creates and returns a new instance of [LMChatMultiMediaConversationPostedState]
  LMChatMultiMediaConversationPostedState(
    this.postConversationResponse,
    this.putMediaResponse,
  );

  @override
  List<Object> get props => [postConversationResponse, putMediaResponse];
}

/// Represents an error state in a multimedia conversation.
class LMChatMultiMediaConversationErrorState extends LMChatConversationState {
  /// The error message.
  final String errorMessage;

  /// A temporary identifier associated with the error.
  final String temporaryId;

  /// Creates and returns a new instance of [LMChatMultiMediaConversationErrorState]
  LMChatMultiMediaConversationErrorState(
    this.errorMessage,
    this.temporaryId,
  );

  @override
  List<Object> get props => [errorMessage, temporaryId];
}
