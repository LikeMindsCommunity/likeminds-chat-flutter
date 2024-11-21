part of '../conversation_action_bloc.dart';

_deleteReactionHandler(LMChatDeleteReaction event, emit) async {
  emit(LMChatDeleteReactionState(
    conversationId: event.conversationId,
    reaction: event.reaction,
  ));
  LMResponse response =
      await LMChatCore.client.deleteReaction((DeleteReactionRequestBuilder()
            ..conversationId(event.conversationId)
            ..reaction(event.reaction))
          .build());
  if (!response.success) {
    emit(LMChatDeleteReactionError(
      errorMessage: response.errorMessage ?? 'An error occurred',
      conversationId: event.conversationId,
      reaction: event.reaction,
    ));
  }
}
