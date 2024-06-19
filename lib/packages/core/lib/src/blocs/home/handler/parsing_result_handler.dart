part of '../home_bloc.dart';

/// Function to parse the response object into List<LMChatRoomViewData>
List<LMChatRoomViewData> parseHomeResponse(GetHomeFeedResponse response) {
  return parseHomeFeedToChatrooms(response);
}

/// Function to parse response, and update child models
List<LMChatRoomViewData> parseHomeFeedToChatrooms(
  GetHomeFeedResponse response,
) {
  final List<LMChatRoomViewData> chatrooms = response.chatroomsData!.map(
    //Convert chatroom model to LMChatRoomViewData
    (chatroom) {
      LMChatRoomViewData chatroomViewData = chatroom.toChatRoomViewData();
      chatroomViewData = parseLastConversation(response, chatroomViewData);
      chatroomViewData = parseChatroomUsers(response, chatroomViewData);
      return chatroomViewData;
    },
  ).toList();
  //Returns a list of LMChatRoomViewData with all models
  return chatrooms;
}

/// Fucntion to parse chatroom users from response user meta
LMChatRoomViewData parseChatroomUsers(
  GetHomeFeedResponse response,
  LMChatRoomViewData chatroom,
) {
  //Convert user model to LMChatUserViewData
  final Map<int, LMChatUserViewData> users = response.userMeta!.map(
    (key, value) => MapEntry(key, value.toUserViewData()),
  );
  //Extract users from users list using IDs
  LMChatUserViewData chatroomUser = users[chatroom.userId]!;
  //Return a copy of passed chatroom with chatroom users updated
  return chatroom.copyWith(
    member: chatroomUser,
  );
}

/// Function to parse the last conversation for this chatroom from conversationMeta
LMChatRoomViewData parseLastConversation(
  GetHomeFeedResponse response,
  LMChatRoomViewData chatroom,
) {
  //Convert last conversation from response to viewData
  LMChatConversationViewData? lastConversation = response
      .conversationMeta![chatroom.lastConversationId.toString()]!
      .toConversationViewData();
  //Create a new instance with member object copied
  LMChatConversationViewData updated = lastConversation.copyWith(
      member: response
          .userMeta![lastConversation.memberId ?? lastConversation.userId]!
          .toUserViewData());
  //Return a copy of passed chatroom with lastConversation updated
  return chatroom.copyWith(lastConversation: updated);
}
