part of '../conversation_action_bloc.dart';

_putReactionHandler(LMChatPutReaction event, emit) async {
  emit(
    LMChatPutReactionState(
      conversationId: event.conversationId,
      reaction: event.reaction,
    ),
  );
  LMResponse response =
      await LMChatCore.client.putReaction((PutReactionRequestBuilder()
            ..conversationId(event.conversationId)
            ..reaction(event.reaction))
          .build());
  if (!response.success) {
    emit(LMChatPutReactionError(
      errorMessage: response.errorMessage ?? 'An error occured',
      conversationId: event.conversationId,
      reaction: event.reaction,
    ));
  }
}
