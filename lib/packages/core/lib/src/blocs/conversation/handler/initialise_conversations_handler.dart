part of '../conversation_bloc.dart';

/// Handler for updating conversations in a chatroom
initialiseConversationsEventHandler(
  LMChatInitialiseConversationsEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  final DatabaseReference realTime = LMChatRealtime.instance.chatroom();
  int? lastConversationId = LMChatConversationBloc.instance.lastConversationId;
  int chatroomId = event.chatroomId;
  lastConversationId = event.conversationId;

  realTime.onValue.listen(
    (event) {
      if (event.snapshot.value != null) {
        final response = event.snapshot.value as Map;
        final conversationId = int.parse(response["collabcard"]["answer_id"]);
        if (lastConversationId != null &&
            conversationId != lastConversationId) {
          LMChatConversationBloc.instance.add(LMChatUpdateConversationsEvent(
            chatroomId: chatroomId,
            conversationId: conversationId,
          ));
        }
      }
    },
  );
}
