part of '../chatroom_action_bloc.dart';

Future<void> _handleMarkReadChatroom(LMChatMarkReadChatroomEvent event) async {
  // ignore: unused_local_variable
  LMResponse response = await LMChatCore.client.markReadChatroom(
      (MarkReadChatroomRequestBuilder()..chatroomId(event.chatroomId)).build());
}
