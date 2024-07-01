part of '../dm_bloc.dart';

/// Function to parse the response object into List<LMChatRoomViewData>
List<LMChatRoomViewData> parseDMResponse(GetHomeFeedResponse response) {
  return parseDMHomeFeedToChatrooms(response);
}

/// Function to parse response, and update child models
List<LMChatRoomViewData> parseDMHomeFeedToChatrooms(
  GetHomeFeedResponse response,
) {
  final List<LMChatRoomViewData> chatrooms = response.chatroomsData!.map(
    //Convert chatroom model to LMChatRoomViewData
    (chatroom) {
      LMChatRoomViewData chatroomViewData = chatroom.toChatRoomViewData();
      chatroomViewData = parseDMLastConversation(response, chatroomViewData);
      chatroomViewData = parseDMChatroomUsers(response, chatroomViewData);
      return chatroomViewData;
    },
  ).toList();
  //Returns a list of LMChatRoomViewData with all models
  return chatrooms;
}

/// Fucntion to parse chatroom users from response user meta
LMChatRoomViewData parseDMChatroomUsers(
  GetHomeFeedResponse response,
  LMChatRoomViewData chatroom,
) {
  //Convert user model to LMChatUserViewData
  final Map<int, LMChatUserViewData> users = response.userMeta!.map(
    (key, value) => MapEntry(key, value.toUserViewData()),
  );
  //Extract users from users list using IDs
  LMChatUserViewData chatroomUser = users[chatroom.userId]!;
  LMChatUserViewData chatroomWithUser = users[chatroom.chatroomWithUserId]!;
  //Return a copy of passed chatroom with chatroom users updated
  return chatroom.copyWith(
    chatroomWithUser: chatroomWithUser,
    member: chatroomUser,
  );
}

/// Function to parse the last conversation for this chatroom from conversationMeta
LMChatRoomViewData parseDMLastConversation(
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
